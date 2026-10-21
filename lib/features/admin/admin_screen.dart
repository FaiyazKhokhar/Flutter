import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';

class _AdminUser {
  final String name;
  final String email;
  int xp;
  bool banned;
  _AdminUser(this.name, this.email, this.xp, {this.banned = false});
}

class _AdminPlaylist {
  final String title;
  final String owner;
  final int videos;
  _AdminPlaylist(this.title, this.owner, this.videos);
}

class _AdminReport {
  final String title;
  final String by;
  _AdminReport(this.title, this.by);
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const _nav = [
    (Icons.dashboard_outlined, 'Overview'),
    (Icons.people_outline, 'Users'),
    (Icons.video_library_outlined, 'Playlists'),
    (Icons.flag_outlined, 'Reports'),
    (Icons.emoji_events_outlined, 'Leaderboard'),
  ];

  static const _danger = Color(0xFFFF6B6B);

  int _tab = 0;
  String _query = '';

  // ---------- mock data ----------
  final List<_AdminUser> _users = [
    _AdminUser('Sara Khan', 'sara@mail.com', 12450),
    _AdminUser('Liam Chen', 'liam@mail.com', 11980),
    _AdminUser('Priya Nair', 'priya@mail.com', 11200),
    _AdminUser('Alex Mercer', 'alex@mail.com', 10150),
    _AdminUser('Omar Diaz', 'omar@mail.com', 9870),
    _AdminUser('Spam Bot', 'bot@spam.io', 20, banned: true),
  ];

  final List<_AdminPlaylist> _playlists = [
    _AdminPlaylist('Advanced React Patterns', 'Alex Mercer', 18),
    _AdminPlaylist('Deep Dive into Go', 'Liam Chen', 24),
    _AdminPlaylist('CSS Grid Mastery', 'Priya Nair', 12),
    _AdminPlaylist('Free XP hack!!!', 'Spam Bot', 3),
  ];

  final List<_AdminReport> _reports = [
    _AdminReport('Spam playlist "Free XP hack!!!"', 'Reported by Sara Khan'),
    _AdminReport('Fake streak claim on leaderboard', 'Reported by Omar Diaz'),
  ];

  static const _signups = [12, 18, 9, 22, 30, 15, 26];
  static const _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  // ---------- helpers ----------
  String _fmt(int n) => n >= 1000
      ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}'
      : '$n';

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface,
        content: Text(
          msg,
          style:
              AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }

  // ---------- build ----------
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 800;
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: wide
            ? null
            : AppBar(
                backgroundColor: AppColors.bg,
                elevation: 0,
                iconTheme: const IconThemeData(color: AppColors.primary),
                title: Text(
                  _nav[_tab].$2,
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    color: AppColors.logoLime,
                  ),
                ),
              ),
        drawer: wide ? null : Drawer(
          backgroundColor: AppColors.navBg,
          child: _sidebar(drawer: true),
        ),
        body: wide
            ? Row(
                children: [
                  SizedBox(width: 240, child: _sidebar()),
                  Expanded(child: _content()),
                ],
              )
            : SafeArea(child: _content()),
      );
    });
  }

  // ---------- sidebar ----------
  Widget _sidebar({bool drawer = false}) {
    return Container(
      color: AppColors.navBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DevCade',
                    style: GoogleFonts.sora(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.logoLime,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('ADMIN PANEL', style: AppTextStyles.caption),
                ],
              ),
            ),
            for (int i = 0; i < _nav.length; i++)
              _navTile(_nav[i].$1, _nav[i].$2, i == _tab, () {
                setState(() => _tab = i);
                if (drawer) Navigator.of(context).pop();
              }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _navTile(Icons.arrow_back, 'Back to app', false, () {
                if (drawer) Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navTile(
      IconData icon, String label, bool active, VoidCallback onTap) {
    final color = active ? const Color(0xFF4D6E00) : AppColors.navInactive;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- content ----------
  Widget _content() {
    Widget page;
    switch (_tab) {
      case 1:
        page = _usersTab();
        break;
      case 2:
        page = _playlistsTab();
        break;
      case 3:
        page = _reportsTab();
        break;
      case 4:
        page = _leaderboardTab();
        break;
      default:
        page = _overview();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: page,
        ),
      ),
    );
  }

  Widget _pageTitle(String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.display.copyWith(fontSize: 32)),
          const SizedBox(height: 4),
          Text(sub, style: AppTextStyles.body),
        ],
      ),
    );
  }

  // ---------- 1. overview ----------
  Widget _overview() {
    final stats = [
      ('TOTAL USERS', '${_users.length}', Icons.people_outline, true),
      ('ACTIVE TODAY', '128', Icons.bolt, false),
      ('PLAYLISTS', '${_playlists.length}', Icons.video_library_outlined,
          false),
      ('OPEN REPORTS', '${_reports.length}', Icons.flag_outlined, false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Overview', 'How DevCade is doing right now.'),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth >= 700 ? 4 : 2;
          final w = (c.maxWidth - 16 * (cols - 1)) / cols;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final s in stats)
                SizedBox(width: w, child: _statCard(s.$1, s.$2, s.$3, s.$4)),
            ],
          );
        }),
        const SizedBox(height: 24),
        _signupChart(),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, bool hi) {
    final fg = hi ? AppColors.bg : AppColors.textPrimary;
    final sub = hi ? AppColors.onPrimaryMuted : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hi ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: hi ? AppColors.primary : AppColors.border),
        boxShadow: hi
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(182, 255, 0, 0.25),
                  offset: Offset(0, 12),
                  blurRadius: 32,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: sub),
                ),
              ),
              Icon(icon, size: 18, color: sub),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.sora(
              fontSize: 36,
              height: 1,
              letterSpacing: -1,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signupChart() {
    const maxV = 30.0;
    const chartH = 120.0;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New signups this week', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          SizedBox(
            height: chartH + 28,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final top = _signups[i] == 30;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${_signups[i]}',
                          style: AppTextStyles.caption.copyWith(
                              color: top
                                  ? AppColors.primary
                                  : AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: (_signups[i] / maxV) * (chartH - 20),
                        decoration: BoxDecoration(
                          color:
                              top ? AppColors.primary : AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_days[i], style: AppTextStyles.caption),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- 2. users ----------
  Widget _usersTab() {
    final q = _query.toLowerCase();
    final list = _users
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q))
        .toList();

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Users', '${_users.length} registered developers.'),
        SizedBox(
          height: 49,
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            cursorColor: AppColors.primary,
            style:
                GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search name or email...',
              hintStyle:
                  GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              prefixIcon: const Icon(Icons.search,
                  size: 20, color: AppColors.textMuted),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (list.isEmpty) _empty('No users found.'),
        for (final u in list) ...[
          _userRow(u),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _userRow(_AdminUser u) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: Text(
              u.name[0],
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        u.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: u.banned
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (u.banned) ...[
                      const SizedBox(width: 8),
                      _tag('BANNED', _danger),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${u.email} · ${_fmt(u.xp)} XP',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _smallBtn(
            u.banned ? 'UNBAN' : 'BAN',
            u.banned ? AppColors.primary : _danger,
            () {
              setState(() => u.banned = !u.banned);
              _toast(u.banned ? '${u.name} banned' : '${u.name} unbanned');
            },
          ),
        ],
      ),
    );
  }

  // ---------- 3. playlists ----------
  Widget _playlistsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Playlists', '${_playlists.length} playlists on the platform.'),
        if (_playlists.isEmpty) _empty('No playlists.'),
        for (final p in List.of(_playlists)) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.oliveChip,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.olive),
                  ),
                  child: const Icon(Icons.play_arrow,
                      size: 22, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'by ${p.owner} · ${p.videos} videos',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Delete playlist',
                  onPressed: () {
                    setState(() => _playlists.remove(p));
                    _toast('Deleted "${p.title}"');
                  },
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: _danger),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ---------- 4. reports ----------
  Widget _reportsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Reports', '${_reports.length} waiting for review.'),
        if (_reports.isEmpty) _empty('All clear. No open reports.'),
        for (final r in List.of(_reports)) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flag, size: 16, color: _danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.title,
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(r.by, style: AppTextStyles.caption),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _smallBtn('DISMISS', AppColors.textSecondary, () {
                      setState(() => _reports.remove(r));
                      _toast('Report dismissed');
                    }),
                    const SizedBox(width: 8),
                    _smallBtn('REMOVE CONTENT', _danger, () {
                      setState(() => _reports.remove(r));
                      _toast('Content removed');
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
  // ---------- 5. leaderboard ----------
  List<_AdminUser> get _ranked {
    final l = _users.where((u) => !u.banned).toList();
    l.sort((a, b) => b.xp.compareTo(a.xp));
    return l;
  }

  void _giveXp(_AdminUser u, int delta) {
    setState(() => u.xp = (u.xp + delta).clamp(0, 999999).toInt());
  }

  Future<void> _resetSeason() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Reset season?', style: AppTextStyles.h3),
        content: Text(
          'This sets every user XP to 0. It cannot be undone.',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('CANCEL',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('RESET',
                style: AppTextStyles.caption.copyWith(color: _danger)),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        for (final u in _users) {
          u.xp = 0;
        }
      });
      _toast('Season reset');
    }
  }

  Widget _leaderboardTab() {
    final ranked = _ranked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageTitle('Leaderboard', 'Gold League. Top 3 get promoted on Sunday.'),
        Row(
          children: [
            Expanded(
              child: Text('${ranked.length} ranked players',
                  style: AppTextStyles.bodySmall),
            ),
            _smallBtn('RESET SEASON', _danger, _resetSeason),
          ],
        ),
        const SizedBox(height: 16),
        if (ranked.isEmpty) _empty('No ranked players.'),
        for (int i = 0; i < ranked.length; i++) ...[
          _rankRow(i + 1, ranked[i]),
          const SizedBox(height: 12),
          if (i == 2 && ranked.length > 3) ...[
            _promotionLine(),
            const SizedBox(height: 12),
          ],
        ],
        if (_users.any((u) => u.banned))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Banned users are hidden from the ranking.',
              style: AppTextStyles.caption,
            ),
          ),
      ],
    );
  }

  Widget _rankRow(int rank, _AdminUser u) {
    final top = rank <= 3;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: top ? AppColors.olive : AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: top ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  u.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text('${_fmt(u.xp)} XP', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _smallBtn('-100', AppColors.textSecondary, () => _giveXp(u, -100)),
          const SizedBox(width: 8),
          _smallBtn('+100', AppColors.primary, () => _giveXp(u, 100)),
        ],
      ),
    );
  }

  Widget _promotionLine() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.olive, height: 1)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.oliveChip,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.olive),
          ),
          child: Text(
            'PROMOTION CUTOFF',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.primary, fontSize: 10),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.olive, height: 1)),
      ],
    );
  }
// ---------- small shared bits ----------
  Widget _smallBtn(String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(9999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
    );
  }

  Widget _empty(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(child: Text(msg, style: AppTextStyles.body)),
    );
  }
}
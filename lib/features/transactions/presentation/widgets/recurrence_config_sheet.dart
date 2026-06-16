import 'package:expenselab/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

enum _Freq { daily, weekly, monthly, yearly }

enum _EndCondition { never, byDate, afterCount }

class RecurrenceConfigSheet extends StatefulWidget {
  const RecurrenceConfigSheet({this.initialRrule, super.key});

  /// Pre-populates the sheet from an existing RFC 5545 rrule string.
  final String? initialRrule;

  @override
  State<RecurrenceConfigSheet> createState() => _RecurrenceConfigSheetState();
}

class _RecurrenceConfigSheetState extends State<RecurrenceConfigSheet> {
  _Freq _freq = _Freq.weekly;
  int _interval = 1;
  // Set of Dart weekday ints (Monday=1 … Sunday=7).
  final Set<int> _weekdays = {DateTime.monday};
  _EndCondition _end = _EndCondition.never;
  DateTime? _endDate;
  int _endCount = 5;

  final _intervalController = TextEditingController(text: '1');
  final _countController = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();
    if (widget.initialRrule != null) {
      _parseInitial(widget.initialRrule!);
    }
  }

  void _parseInitial(String rruleStr) {
    try {
      final rule = RecurrenceRule.fromString(rruleStr);
      final freq = rule.frequency;
      if (freq == Frequency.daily) {
        _freq = _Freq.daily;
      } else if (freq == Frequency.weekly) {
        _freq = _Freq.weekly;
      } else if (freq == Frequency.monthly) {
        _freq = _Freq.monthly;
      } else if (freq == Frequency.yearly) {
        _freq = _Freq.yearly;
      }

      _interval = rule.interval ?? 1;
      _intervalController.text = _interval.toString();

      if (rule.byWeekDays.isNotEmpty) {
        _weekdays
          ..clear()
          ..addAll(rule.byWeekDays.map((e) => e.day));
      }

      if (rule.until != null) {
        _end = _EndCondition.byDate;
        _endDate = rule.until!.toLocal();
      } else if (rule.count != null) {
        _end = _EndCondition.afterCount;
        _endCount = rule.count!;
        _countController.text = _endCount.toString();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _countController.dispose();
    super.dispose();
  }

  String _buildRrule() {
    final Frequency freq;
    if (_freq == _Freq.daily) {
      freq = Frequency.daily;
    } else if (_freq == _Freq.monthly) {
      freq = Frequency.monthly;
    } else if (_freq == _Freq.yearly) {
      freq = Frequency.yearly;
    } else {
      freq = Frequency.weekly;
    }

    List<ByWeekDayEntry>? byWeekDays;
    if (_freq == _Freq.weekly && _weekdays.isNotEmpty) {
      byWeekDays = _weekdays.map(ByWeekDayEntry.new).toList();
    }

    DateTime? until;
    int? count;
    if (_end == _EndCondition.byDate && _endDate != null) {
      until = _endDate!.toUtc();
    } else if (_end == _EndCondition.afterCount) {
      count = _endCount;
    }

    final rule = RecurrenceRule(
      frequency: freq,
      interval: _interval > 1 ? _interval : null,
      byWeekDays: byWeekDays ?? const [],
      until: until,
      count: count,
    );
    return rule.toString();
  }

  List<DateTime> _previewDates() {
    try {
      final rule = RecurrenceRule.fromString(_buildRrule());
      return rule
          .getAllInstances(
            start: DateTime.now().toUtc(),
            before: DateTime.now().toUtc().add(const Duration(days: 1000)),
            includeBefore: true,
          )
          .take(3)
          .map((d) => d.toLocal())
          .toList();
    } catch (_) {
      return [];
    }
  }

  String _freqLabel(_Freq f) => switch (f) {
        _Freq.daily => 'Daily',
        _Freq.weekly => 'Weekly',
        _Freq.monthly => 'Monthly',
        _Freq.yearly => 'Yearly',
      };

  String _weekdayLabel(int day) => const {
        DateTime.monday: 'Mon',
        DateTime.tuesday: 'Tue',
        DateTime.wednesday: 'Wed',
        DateTime.thursday: 'Thu',
        DateTime.friday: 'Fri',
        DateTime.saturday: 'Sat',
        DateTime.sunday: 'Sun',
      }[day]!;

  String _intervalUnitLabel() => switch (_freq) {
        _Freq.daily => _interval == 1 ? 'day' : 'days',
        _Freq.weekly => _interval == 1 ? 'week' : 'weeks',
        _Freq.monthly => _interval == 1 ? 'month' : 'months',
        _Freq.yearly => _interval == 1 ? 'year' : 'years',
      };

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final preview = _previewDates();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, sc) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Repeat',
                  style: TextStyle(
                    fontFamily: 'Epilogue',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, ''),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      fontFamily: 'Epilogue',
                      fontSize: 13,
                      color: cs.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                // ── Frequency ─────────────────────────────────────────────────
                const _SectionLabel('Frequency'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _Freq.values.map((f) {
                    final selected = _freq == f;
                    return ChoiceChip(
                      label: Text(
                        _freqLabel(f),
                        style: TextStyle(
                          fontFamily: 'Epilogue',
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? Colors.white : cs.onSurface,
                        ),
                      ),
                      selected: selected,
                      selectedColor: cs.primary,
                      backgroundColor: cs.surfaceContainerHighest,
                      onSelected: (_) => setState(() {
                        _freq = f;
                        if (f == _Freq.weekly && _weekdays.isEmpty) {
                          _weekdays.add(DateTime.monday);
                        }
                      }),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ── Interval ──────────────────────────────────────────────────
                const _SectionLabel('Every'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 64,
                      child: TextField(
                        controller: _intervalController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Epilogue', fontSize: 16, color: cs.onSurface),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onChanged: (v) {
                          final n = int.tryParse(v);
                          if (n != null && n >= 1) setState(() => _interval = n);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _intervalUnitLabel(),
                      style: TextStyle(fontFamily: 'Epilogue', fontSize: 15, color: cs.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Day-of-week (weekly only) ─────────────────────────────────
                if (_freq == _Freq.weekly) ...[
                  const _SectionLabel('On'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (int day = DateTime.monday; day <= DateTime.sunday; day++)
                        FilterChip(
                          label: Text(
                            _weekdayLabel(day),
                            style: TextStyle(
                              fontFamily: 'Epilogue',
                              fontSize: 12,
                              fontWeight: _weekdays.contains(day) ? FontWeight.w600 : FontWeight.w400,
                              color: _weekdays.contains(day) ? Colors.white : cs.onSurface,
                            ),
                          ),
                          selected: _weekdays.contains(day),
                          selectedColor: cs.primary,
                          backgroundColor: cs.surfaceContainerHighest,
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              _weekdays.add(day);
                            } else if (_weekdays.length > 1) {
                              _weekdays.remove(day);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // ── End condition ─────────────────────────────────────────────
                const _SectionLabel('Ends'),
                const SizedBox(height: 8),
                _EndOption(
                  label: 'Never',
                  selected: _end == _EndCondition.never,
                  onTap: () => setState(() => _end = _EndCondition.never),
                ),
                const SizedBox(height: 8),
                _EndOption(
                  label: 'On date',
                  trailing: _end == _EndCondition.byDate && _endDate != null
                      ? Text(
                          DateFormat('MMM dd, yyyy').format(_endDate!),
                          style: TextStyle(fontFamily: 'Epilogue', fontSize: 13, color: cs.primary),
                        )
                      : null,
                  selected: _end == _EndCondition.byDate,
                  onTap: () async {
                    setState(() => _end = _EndCondition.byDate);
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null && mounted) setState(() => _endDate = date);
                  },
                ),
                const SizedBox(height: 8),
                _EndOption(
                  label: 'After',
                  trailing: _end == _EndCondition.afterCount
                      ? SizedBox(
                          width: 64,
                          child: TextField(
                            controller: _countController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Epilogue', fontSize: 14, color: cs.onSurface),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              suffix: Text('×', style: TextStyle(fontFamily: 'Epilogue', color: cs.onSurfaceVariant)),
                            ),
                            onChanged: (v) {
                              final n = int.tryParse(v);
                              if (n != null && n >= 1) setState(() => _endCount = n);
                            },
                          ),
                        )
                      : null,
                  selected: _end == _EndCondition.afterCount,
                  onTap: () => setState(() => _end = _EndCondition.afterCount),
                ),
                const SizedBox(height: 24),

                // ── Preview ───────────────────────────────────────────────────
                if (preview.isNotEmpty) ...[
                  const _SectionLabel('Next occurrences'),
                  const SizedBox(height: 8),
                  ...preview.map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: cs.primary),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('EEEE, MMM dd, yyyy').format(d),
                            style: TextStyle(fontFamily: 'Epilogue', fontSize: 13, color: cs.onSurface),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Confirm ───────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _buildRrule()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontFamily: 'Epilogue', fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: cs.primary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _EndOption extends StatelessWidget {
  const _EndOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: cs.primary, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: selected ? cs.primary : cs.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? cs.primary : cs.onSurface,
              ),
            ),
            const Spacer(),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

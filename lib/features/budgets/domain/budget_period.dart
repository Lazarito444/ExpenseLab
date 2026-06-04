enum BudgetPeriod {
  monthly,
  weekly,
  yearly;

  String toRrule() {
    switch (this) {
      case BudgetPeriod.monthly:
        return 'FREQ=MONTHLY';
      case BudgetPeriod.weekly:
        return 'FREQ=WEEKLY';
      case BudgetPeriod.yearly:
        return 'FREQ=YEARLY';
    }
  }

  static BudgetPeriod fromRrule(String? rrule) {
    switch (rrule) {
      case 'FREQ=WEEKLY':
        return BudgetPeriod.weekly;
      case 'FREQ=YEARLY':
        return BudgetPeriod.yearly;
      default:
        return BudgetPeriod.monthly;
    }
  }
}

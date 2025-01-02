enum Priority {
  essential,
  normal,
  low
}

extension PriorityExtension on Priority {
  String get label {
    switch (this) {
      case Priority.essential:
        return 'essential';
      case Priority.normal:
        return 'normal';
      case Priority.low:
        return 'low';
      }
  }
}

enum FrequencyTransaction {
  weekly,
  monthly,
  yearly,
  unique
}


extension FrequencyTransactionExtension on FrequencyTransaction {
  String get label {
    switch (this) {
      case FrequencyTransaction.weekly:
        return 'weekly';
      case FrequencyTransaction.monthly:
        return 'monthly';
      case FrequencyTransaction.yearly:
        return 'yearly';
      case FrequencyTransaction.unique:
        return 'unique';

    }
  }
}

enum Frequency {
  daily,
  mondayToFriday,
  weekly,
  monthly,
  yearly,
  unique
}

extension FrequencyExtension on Frequency {
  String get label {
    switch (this) {
      case Frequency.daily:
        return 'daily';
      case Frequency.mondayToFriday:
        return 'mondayToFriday';
      case Frequency.weekly:
        return 'weekly';
      case Frequency.monthly:
        return 'monthly';
      case Frequency.yearly:
        return 'yearly';
      case Frequency.unique:
        return 'unique';
    }
  }
}
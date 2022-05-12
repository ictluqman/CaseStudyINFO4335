import 'dart:io';

class Venue {
  late int id;

  Venue(this.id) {}
}

class VenueReserved {
  late Venue venue;
  late DateTime reservedStartAt;
  late DateTime reservedEndAt;
  late String reservedBy;

  VenueReserved(
      this.venue, this.reservedStartAt, this.reservedEndAt, this.reservedBy) {}

  bool checkDateTimeMatches(DateTime reservedStartAt, DateTime reservedEndAt) {
    if ((reservedStartAt.isAfter(this.reservedStartAt) &&
            reservedStartAt.isBefore(this.reservedEndAt)) ||
        (reservedEndAt.isAfter(this.reservedStartAt) &&
            reservedEndAt.isBefore(this.reservedEndAt)) ||
        reservedStartAt.isAtSameMomentAs(this.reservedStartAt) ||
        reservedStartAt.isAtSameMomentAs(this.reservedEndAt) ||
        reservedEndAt.isAtSameMomentAs(this.reservedStartAt) ||
        reservedEndAt.isAtSameMomentAs(this.reservedEndAt)) return true;
    return false;
  }
}

void main() {
  var totalVenues = 30;

  Map<int, Venue> venues = {};
  Map<int, List<VenueReserved>> venuesReserved = {};

  for (int i = 1; i <= totalVenues; i++) {
    venues[i] = Venue(i);
    venuesReserved[i] = [];
  }

  while (true) {
    print("Venue Reservation System:");
    print("1. Reserve a venue");
    // print("2. Check reserve name");
    print("2. Exit");

    stdout.write("Enter your choice: ");
    int input = int.parse(stdin.readLineSync()!);

    if (input == 1) {
      reserveVenue(venues, venuesReserved);
    } else {
      break;
    }

    print('\n');
  }
}

void reserveVenue(
    Map<int, Venue> venues, Map<int, List<VenueReserved>> venuesReserved) {
  print('\n\nWe are operating from 8:00 to 23:00.');

  outerLoop:
  while (true) {
    stdout.write("Enter venue ID (1-30): ");
    int enteredVenueId = int.parse(stdin.readLineSync()!);
    print('');

    if (enteredVenueId < 1 || enteredVenueId > 30) {
      print('We only have 30 venues! Please try again.');
      continue;
    }

    print("Reservation start at ");
    stdout.write("Date (D/M/YY like 22/8/2022): ");
    String enteredStartDate = stdin.readLineSync()!;
    stdout.write("Time (HH:MM like 14:30): ");
    String enteredStartTime = stdin.readLineSync()!;
    print('');

    print("Reservation end at ");
    stdout.write("Date (D/M/YY like 22/8/2022): ");
    String enteredEndDate = stdin.readLineSync()!;
    stdout.write("Time (HH:MM like 14:30): ");
    String enteredEndTime = stdin.readLineSync()!;
    print('');

    var startDate = enteredStartDate.split('/');
    var startTime = enteredStartTime.split(':');

    var reservedStartAt = DateTime(
      int.parse(startDate[2]),
      int.parse(startDate[1]),
      int.parse(startDate[0]),
      int.parse(startTime[0]),
      int.parse(startTime[1]),
    );

    var endDate = enteredEndDate.split('/');
    var endTime = enteredEndTime.split(':');

    var reservedEndAt = DateTime(
      int.parse(endDate[2]),
      int.parse(endDate[1]),
      int.parse(endDate[0]),
      int.parse(endTime[0]),
      int.parse(endTime[1]),
    );

    if (int.parse(startTime[0]) < 8 || int.parse(endTime[0]) > 23) {
      print(
          'We are closed at that time! Please choose time between 8:00 to 23:00.');
      continue;
    }

    if (reservedEndAt.isBefore(reservedStartAt)) {
      print('Invalid date or time! Please try again.');
      continue;
    }

    for (VenueReserved reservedVenue in venuesReserved[enteredVenueId]!) {
      if (reservedVenue.checkDateTimeMatches(reservedStartAt, reservedEndAt)) {
        print(
            'We already have a reservation at that time! Please choose another time.');
        continue outerLoop;
      }
    }

    stdout.write("Enter your name: ");
    String enteredName = stdin.readLineSync()!;

    venuesReserved[enteredVenueId]!.add(VenueReserved(
        venues[enteredVenueId]!, reservedStartAt, reservedEndAt, enteredName));

    break;
  }
}

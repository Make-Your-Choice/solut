import 'package:solut/shared/consts/card_number.dart';
import 'package:solut/shared/consts/card_type.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';
import 'package:solut/shared/data_calsses/suit_data_class.dart';

final cards = [
  ...List.generate(CardNumber.values.length, (index) =>
      SuitCardDataClass(
          suit: SuitDataClass(type: SuitType.spades, color: SuitColor.black),
          number: CardNumber.values[index])),
  ...List.generate(CardNumber.values.length, (index) =>
      SuitCardDataClass(
          suit: SuitDataClass(type: SuitType.clubs, color: SuitColor.black),
          number: CardNumber.values[index])),
  ...List.generate(CardNumber.values.length, (index) =>
      SuitCardDataClass(
          suit: SuitDataClass(type: SuitType.diamonds, color: SuitColor.red),
          number: CardNumber.values[index])),
  ...List.generate(CardNumber.values.length, (index) =>
      SuitCardDataClass(
          suit: SuitDataClass(type: SuitType.hearts, color: SuitColor.red),
          number: CardNumber.values[index]))
];
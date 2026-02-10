import 'package:solut/shared/consts/card_number.dart';
import 'package:solut/shared/consts/card_type.dart';
import 'package:solut/shared/data_calsses/suit_card_data_class.dart';

final cards = [
  ...List.generate(CardNumber.values.length, (index) => SuitCardDataClass(suit: SuitType.spades, number: CardNumber.values[index])),
  ...List.generate(CardNumber.values.length, (index) => SuitCardDataClass(suit: SuitType.clubs, number: CardNumber.values[index])),
  ...List.generate(CardNumber.values.length, (index) => SuitCardDataClass(suit: SuitType.diamonds, number: CardNumber.values[index])),
  ...List.generate(CardNumber.values.length, (index) => SuitCardDataClass(suit: SuitType.hearts, number: CardNumber.values[index]))
];
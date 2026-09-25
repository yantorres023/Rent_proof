/// Built-in room templates with guided capture prompts.
///
/// Prompts are deliberately short and concrete so a stressed renter can
/// follow them without knowing inspection jargon.
class RoomTemplate {
  const RoomTemplate({
    required this.key,
    required this.name,
    required this.prompts,
  });

  final String key;
  final String name;
  final List<String> prompts;
}

const _base = ['Overview', 'Walls & ceiling', 'Floor', 'Windows & blinds'];

const roomTemplates = <RoomTemplate>[
  RoomTemplate(
    key: 'entry',
    name: 'Entry & hallway',
    prompts: [..._base, 'Front door & lock', 'Lights & switches'],
  ),
  RoomTemplate(
    key: 'living',
    name: 'Living room',
    prompts: [..._base, 'Outlets & lights', 'Heating / AC vents'],
  ),
  RoomTemplate(
    key: 'kitchen',
    name: 'Kitchen',
    prompts: [
      'Overview',
      'Walls & ceiling',
      'Floor',
      'Countertops',
      'Cabinets & drawers',
      'Sink & faucet',
      'Stove & oven',
      'Refrigerator',
      'Dishwasher',
      'Windows & blinds',
    ],
  ),
  RoomTemplate(
    key: 'dining',
    name: 'Dining area',
    prompts: [..._base, 'Lights'],
  ),
  RoomTemplate(
    key: 'bedroom',
    name: 'Bedroom',
    prompts: [..._base, 'Closet', 'Door', 'Outlets & lights'],
  ),
  RoomTemplate(
    key: 'bathroom',
    name: 'Bathroom',
    prompts: [
      'Overview',
      'Walls & ceiling',
      'Floor',
      'Toilet',
      'Sink & vanity',
      'Shower / tub',
      'Mirror & cabinet',
      'Fan & lights',
    ],
  ),
  RoomTemplate(
    key: 'laundry',
    name: 'Laundry',
    prompts: ['Overview', 'Washer', 'Dryer', 'Floor'],
  ),
  RoomTemplate(
    key: 'storage',
    name: 'Closet / storage',
    prompts: ['Overview', 'Walls & shelves', 'Floor'],
  ),
  RoomTemplate(
    key: 'outdoor',
    name: 'Balcony / patio',
    prompts: ['Overview', 'Floor / decking', 'Railings', 'Door'],
  ),
  RoomTemplate(
    key: 'utilities',
    name: 'Keys, meters & safety',
    prompts: [
      'Keys & remotes received',
      'Smoke / CO detectors',
      'Meter readings',
      'Thermostat',
    ],
  ),
];

/// Default rooms offered for a new inspection of a typical apartment.
const defaultRoomKeys = ['entry', 'living', 'kitchen', 'bedroom', 'bathroom'];

/// Prompts used for user-defined rooms.
const customRoomPrompts = ['Overview', 'Walls & ceiling', 'Floor'];

RoomTemplate? templateForKey(String key) {
  for (final t in roomTemplates) {
    if (t.key == key) return t;
  }
  return null;
}

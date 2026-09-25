import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/property_repository.dart';
import '../../providers.dart';
import '../widgets/common.dart';

/// Creates a property (pops with its id) or edits [existing].
class PropertyFormScreen extends ConsumerStatefulWidget {
  const PropertyFormScreen({super.key, this.existing});

  final Property? existing;

  @override
  ConsumerState<PropertyFormScreen> createState() => _PropertyFormState();
}

class _PropertyFormState extends ConsumerState<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nickname = TextEditingController(text: widget.existing?.nickname);
  late final _address1 = TextEditingController(
    text: widget.existing?.addressLine1,
  );
  late final _address2 = TextEditingController(
    text: widget.existing?.addressLine2,
  );
  late final _city = TextEditingController(text: widget.existing?.city);
  late final _region = TextEditingController(text: widget.existing?.region);
  late final _postal = TextEditingController(text: widget.existing?.postalCode);
  late final _landlord = TextEditingController(
    text: widget.existing?.landlordName,
  );
  late final _notes = TextEditingController(text: widget.existing?.notes);
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [
      _nickname,
      _address1,
      _address2,
      _city,
      _region,
      _postal,
      _landlord,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final input = PropertyInput(
      nickname: _nickname.text,
      addressLine1: _address1.text,
      addressLine2: _address2.text,
      city: _city.text,
      region: _region.text,
      postalCode: _postal.text,
      country: widget.existing?.country ?? 'United States',
      landlordName: _landlord.text,
      notes: _notes.text,
    );
    final repo = ref.read(propertyRepositoryProvider);
    final saved = await runGuarded(
      context,
      () => widget.existing == null
          ? repo.create(input)
          : repo.update(widget.existing!.id, input),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved != null) Navigator.of(context).pop(saved.id);
  }

  Widget _field(
    TextEditingController c,
    String label, {
    String? hint,
    int maxLength = 120,
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    TextCapitalization caps = TextCapitalization.words,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label, hintText: hint),
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: 1,
      keyboardType: keyboard,
      textCapitalization: caps,
      validator: validator,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit place' : 'Add your place')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(
              _nickname,
              'Name for this place *',
              hint: 'e.g. Maple St apartment',
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter a name'
                  : null,
            ),
            Text(
              'Address (optional, appears on your report)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            _field(_address1, 'Street address', maxLength: 200),
            _field(_address2, 'Unit / apartment', maxLength: 200),
            _field(_city, 'City', maxLength: 100),
            Row(
              children: [
                Expanded(child: _field(_region, 'State', maxLength: 100)),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _postal,
                    'ZIP code',
                    maxLength: 20,
                    keyboard: TextInputType.streetAddress,
                  ),
                ),
              ],
            ),
            _field(_landlord, 'Landlord or property manager (optional)'),
            _field(
              _notes,
              'Notes (optional)',
              maxLength: 2000,
              maxLines: 4,
              caps: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(editing ? 'Save changes' : 'Save place'),
            ),
          ],
        ),
      ),
    );
  }
}

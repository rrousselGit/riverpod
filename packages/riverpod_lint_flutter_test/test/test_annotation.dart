class TestFor {
  const TestFor(this.id);

  static const wrap_with_consumer = TestFor('wrap_with_consumer');
  static const wrap_with_provider_scope = TestFor('wrap_with_provider_scope');
  static const class_based_to_functional_provider = TestFor(
    'class_based_to_functional_provider',
  );
  static const functional_to_class_based_provider = TestFor(
    'functional_to_class_based_provider',
  );
  static const convert_to_hookConsumerWidget = TestFor(
    'convert_to_hookConsumerWidget',
  );
  static const convert_to_hookWidget = TestFor('convert_to_hookWidget');
  static const convert_to_consumerWidget = TestFor('convert_to_consumerWidget');
  static const convert_to_statelessWidget = TestFor(
    'convert_to_statelessWidget',
  );
  static const convert_to_statefulHookConsumerWidget = TestFor(
    'convert_to_statefulHookConsumerWidget',
  );
  static const convert_to_statefulHookWidget = TestFor(
    'convert_to_statefulHookWidget',
  );
  static const convert_to_consumerStatefulWidget = TestFor(
    'convert_to_consumerStatefulWidget',
  );
  static const convert_to_statefulWidget = TestFor('convert_to_statefulWidget');
  static const remove_null_check_pattern_and_add_has_data_check = TestFor(
    'remove_null_check_pattern_and_add_has_data_check',
  );
  static const functional_ref = TestFor('functional_ref');
  static const missing_provider_scope = TestFor('missing_provider_scope');
  static const notifier_build = TestFor('notifier_build');
  static const notifier_extends = TestFor('notifier_extends');
  static const provider_dependencies = TestFor('provider_dependencies');
  static const async_value_nullable_pattern = TestFor(
    'async_value_nullable_pattern',
  );
  static const avoid_build_context_in_providers = TestFor(
    'avoid_build_context_in_providers',
  );
  static const avoid_public_notifier_properties = TestFor(
    'avoid_public_notifier_properties',
  );
  static const avoid_ref_inside_state_dispose = TestFor(
    'avoid_ref_inside_state_dispose',
  );
  static const only_use_keep_alive_inside_keep_alive = TestFor(
    'only_use_keep_alive_inside_keep_alive',
  );
  static const protected_notifier_properties = TestFor(
    'protected_notifier_properties',
  );
  static const provider_parameters = TestFor('provider_parameters');
  static const riverpod_syntax_error = TestFor('riverpod_syntax_error');
  static const scoped_providers_should_specify_dependencies = TestFor(
    'scoped_providers_should_specify_dependencies',
  );
  static const unsupported_provider_value = TestFor(
    'unsupported_provider_value',
  );

  final String id;
}

// @dart=2.12
// ignore: unused_element, unused_import, unnecessary_this

library models.k8s;

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

part 'kubernetes/helper.dart';

// generted by make
//

part 'kubernetes/io_k8s_api_discovery_v1_for_zone.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_horizontal_pod_autoscaler_status.dart';
part 'kubernetes/io_k8s_api_core_v1_projected_volume_source.dart';
part 'kubernetes/io_k8s_api_storage_v1_storage_class.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_external_metric_source.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_priority_level_configuration_reference.dart';
part 'kubernetes/io_k8s_api_core_v1_attached_volume.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_flow_schema.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_hpa_scaling_rules.dart';
part 'kubernetes/io_k8s_api_core_v1_secret_projection.dart';
part 'kubernetes/io_k8s_api_core_v1_tcp_socket_action.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set_persistent_volume_claim_retention_policy.dart';
part 'kubernetes/io_k8s_api_storage_v1beta1_csi_storage_capacity_list.dart';
part 'kubernetes/io_k8s_api_core_v1_event_list.dart';
part 'kubernetes/io_k8s_api_core_v1_endpoint_subset.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_service_account_subject.dart';
part 'kubernetes/io_k8s_api_core_v1_git_repo_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_env_var_source.dart';
part 'kubernetes/io_k8s_api_authorization_v1_subject_access_review_spec.dart';
part 'kubernetes/io_k8s_api_apps_v1_daemon_set_condition.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_container_resource_metric_source.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_flow_schema_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_flow_schema_spec.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_tls.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_conversion.dart';
part 'kubernetes/io_k8s_api_batch_v1_job_status.dart';
part 'kubernetes/io_k8s_api_core_v1_preferred_scheduling_term.dart';
part 'kubernetes/io_k8s_api_core_v1_container_state_running.dart';
part 'kubernetes/io_k8s_api_coordination_v1_lease.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_subject.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_flow_schema_list.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_list.dart';
part 'kubernetes/io_k8s_api_core_v1_node_list.dart';
part 'kubernetes/io_k8s_api_batch_v1_job_condition.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_storage_capacity_list.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_api_resource.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_watch_event.dart';
part 'kubernetes/io_k8s_kube_aggregator_pkg_apis_apiregistration_v1_api_service_list.dart';
part 'kubernetes/io_k8s_api_core_v1_node.dart';
part 'kubernetes/io_k8s_api_core_v1_downward_api_projection.dart';
part 'kubernetes/io_k8s_api_core_v1_scoped_resource_selector_requirement.dart';
part 'kubernetes/io_k8s_api_core_v1_scale_io_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_apps_v1_rolling_update_stateful_set_strategy.dart';
part 'kubernetes/io_k8s_api_core_v1_container.dart';
part 'kubernetes/io_k8s_api_core_v1_vsphere_virtual_disk_volume_source.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_limited_priority_level_configuration.dart';
part 'kubernetes/io_k8s_api_rbac_v1_cluster_role_binding.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_priority_level_configuration_status.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_error.dart';
part 'kubernetes/io_k8s_api_core_v1_rbd_persistent_volume_source.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_condition.dart';
part 'kubernetes/io_k8s_api_authorization_v1_resource_rule.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_list_meta.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_os.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_queuing_configuration.dart';
part 'kubernetes/io_k8s_api_apiserverinternal_v1alpha1_storage_version_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_load_balancer_status.dart';
part 'kubernetes/io_k8s_api_apps_v1_replica_set_condition.dart';
part 'kubernetes/io_k8s_api_rbac_v1_role_ref.dart';
part 'kubernetes/io_k8s_api_core_v1_client_ip_config.dart';
part 'kubernetes/io_k8s_kube_aggregator_pkg_apis_apiregistration_v1_api_service_status.dart';
part 'kubernetes/io_k8s_api_authorization_v1_subject_access_review_status.dart';
part 'kubernetes/io_k8s_api_apps_v1_deployment_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_horizontal_pod_autoscaler.dart';
part 'kubernetes/io_k8s_api_core_v1_secret_list.dart';
part 'kubernetes/io_k8s_api_core_v1_portworx_volume_source.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_status.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_ingress_rule.dart';
part 'kubernetes/io_k8s_api_core_v1_node_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_namespace.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim_volume_source.dart';
part 'kubernetes/io_k8s_api_apps_v1_controller_revision.dart';
part 'kubernetes/io_k8s_api_authorization_v1_self_subject_access_review.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_spec.dart';
part 'kubernetes/io_k8s_api_rbac_v1_cluster_role.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_flow_distinguisher_method.dart';
part 'kubernetes/io_k8s_api_batch_v1_job.dart';
part 'kubernetes/io_k8s_api_core_v1_empty_dir_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_resource_quota_status.dart';
part 'kubernetes/io_k8s_api_core_v1_namespace_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_replication_controller_condition.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_mutating_webhook_configuration.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_template_list.dart';
part 'kubernetes/io_k8s_api_storage_v1_storage_class_list.dart';
part 'kubernetes/io_k8s_api_core_v1_container_status.dart';
part 'kubernetes/io_k8s_api_discovery_v1_endpoint_slice_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_container_resource_metric_status.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_node_spec.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_node_driver.dart';
part 'kubernetes/io_k8s_api_core_v1_secret.dart';
part 'kubernetes/io_k8s_api_core_v1_limit_range_item.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_class_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_flex_volume_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_external_metric_status.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_metric_status.dart';
part 'kubernetes/io_k8s_api_networking_v1_service_backend_port.dart';
part 'kubernetes/io_k8s_api_core_v1_namespace_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_horizontal_pod_autoscaler_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_typed_local_object_reference.dart';
part 'kubernetes/io_k8s_api_authentication_v1_token_request_spec.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_resource_policy_rule.dart';
part 'kubernetes/io_k8s_api_core_v1_limit_range_spec.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_service_account_subject.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_horizontal_pod_autoscaler.dart';
part 'kubernetes/io_k8s_api_apps_v1_deployment_status.dart';
part 'kubernetes/io_k8s_api_apps_v1_deployment_condition.dart';
part 'kubernetes/io_k8s_api_events_v1_event_series.dart';
part 'kubernetes/io_k8s_api_core_v1_glusterfs_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_apiserverinternal_v1alpha1_storage_version_status.dart';
part 'kubernetes/io_k8s_api_core_v1_container_state_terminated.dart';
part 'kubernetes/io_k8s_api_core_v1_volume_mount.dart';
part 'kubernetes/io_k8s_api_node_v1_scheduling.dart';
part 'kubernetes/io_k8s_api_core_v1_component_status_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_horizontal_pod_autoscaler_condition.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_horizontal_pod_autoscaler_list.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_affinity_term.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim.dart';
part 'kubernetes/io_k8s_api_core_v1_service_spec.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_priority_level_configuration_status.dart';
part 'kubernetes/io_k8s_api_core_v1_sysctl.dart';
part 'kubernetes/io_k8s_api_authentication_v1_token_request_status.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_subresource_scale.dart';
part 'kubernetes/io_k8s_api_core_v1_csi_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_event.dart';
part 'kubernetes/io_k8s_api_batch_v1_cron_job_status.dart';
part 'kubernetes/io_k8s_kube_aggregator_pkg_apis_apiregistration_v1_api_service.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_port.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_webhook_client_config.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_cross_version_object_reference.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_validation.dart';
part 'kubernetes/io_k8s_api_coordination_v1_lease_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_hpa_scaling_policy.dart';
part 'kubernetes/io_k8s_api_batch_v1_pod_failure_policy_rule.dart';
part 'kubernetes/io_k8s_api_core_v1_resource_requirements.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_hpa_scaling_rules.dart';
part 'kubernetes/io_k8s_api_core_v1_se_linux_options.dart';
part 'kubernetes/io_k8s_api_core_v1_node_selector_requirement.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_owner_reference.dart';
part 'kubernetes/io_k8s_api_apps_v1_controller_revision_list.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_webhook_conversion.dart';
part 'kubernetes/io_k8s_api_policy_v1_eviction.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map_env_source.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_driver_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_horizontal_pod_autoscaler_list.dart';
part 'kubernetes/io_k8s_api_core_v1_endpoints_list.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_json_schema_props.dart';
part 'kubernetes/io_k8s_api_apps_v1_daemon_set_spec.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_metric_value_status.dart';
part 'kubernetes/io_k8s_api_core_v1_host_path_volume_source.dart';
part 'kubernetes/io_k8s_api_certificates_v1_certificate_signing_request_spec.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_cross_version_object_reference.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_attachment_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_scale_status.dart';
part 'kubernetes/io_k8s_api_policy_v1_pod_disruption_budget_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_security_context.dart';
part 'kubernetes/io_k8s_api_core_v1_storage_os_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_spec.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_backend.dart';
part 'kubernetes/io_k8s_api_core_v1_windows_security_context_options.dart';
part 'kubernetes/io_k8s_api_discovery_v1_endpoint_hints.dart';
part 'kubernetes/io_k8s_api_core_v1_flocker_volume_source.dart';
part 'kubernetes/io_k8s_api_rbac_v1_role_binding.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_list.dart';
part 'kubernetes/io_k8s_api_networking_v1alpha1_cluster_cidr_spec.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_delete_options.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_version_info.dart';
part 'kubernetes/io_k8s_api_core_v1_node_system_info.dart';
part 'kubernetes/io_k8s_api_discovery_v1_endpoint.dart';
part 'kubernetes/io_k8s_api_batch_v1_cron_job.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_resource_metric_source.dart';
part 'kubernetes/io_k8s_api_core_v1_cinder_persistent_volume_source.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_label_selector_requirement.dart';
part 'kubernetes/io_k8s_api_core_v1_resource_quota_list.dart';
part 'kubernetes/io_k8s_api_core_v1_rbd_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_topology_spread_constraint.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_priority_level_configuration_list.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_pods_metric_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_flow_schema_status.dart';
part 'kubernetes/io_k8s_api_core_v1_security_context.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_class.dart';
part 'kubernetes/io_k8s_api_events_v1_event_list.dart';
part 'kubernetes/io_k8s_api_rbac_v1_role_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_scale_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_env_from_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_resource_metric_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_priority_level_configuration_reference.dart';
part 'kubernetes/io_k8s_api_core_v1_endpoints.dart';
part 'kubernetes/io_k8s_api_batch_v1_cron_job_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_pods_metric_source.dart';
part 'kubernetes/io_k8s_api_batch_v1_pod_failure_policy.dart';
part 'kubernetes/io_k8s_api_core_v1_port_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_non_resource_policy_rule.dart';
part 'kubernetes/io_k8s_api_discovery_v1_endpoint_conditions.dart';
part 'kubernetes/io_k8s_api_core_v1_event_series.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_metric_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_component_condition.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_azure_file_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_node_config_status.dart';
part 'kubernetes/io_k8s_api_discovery_v1_endpoint_port.dart';
part 'kubernetes/io_k8s_api_authentication_v1_user_info.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_mutating_webhook_configuration_list.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_group_version_for_discovery.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set_spec.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_flow_schema_condition.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_limit_response.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_object_metric_source.dart';
part 'kubernetes/io_k8s_api_core_v1_replication_controller_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_secret_reference.dart';
part 'kubernetes/io_k8s_api_core_v1_secret_volume_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_object_metric_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_horizontal_pod_autoscaler_list.dart';
part 'kubernetes/io_k8s_api_core_v1_session_affinity_config.dart';
part 'kubernetes/io_k8s_api_policy_v1_pod_disruption_budget.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_metric_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_limit_response.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_attachment_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_container_image.dart';
part 'kubernetes/io_k8s_api_core_v1_csi_volume_source.dart';
part 'kubernetes/io_k8s_api_batch_v1_pod_failure_policy_on_pod_conditions_pattern.dart';
part 'kubernetes/io_k8s_api_core_v1_iscsi_volume_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_cross_version_object_reference.dart';
part 'kubernetes/io_k8s_api_core_v1_key_to_path.dart';
part 'kubernetes/io_k8s_api_apps_v1_replica_set_list.dart';
part 'kubernetes/io_k8s_api_batch_v1_job_list.dart';
part 'kubernetes/io_k8s_api_core_v1_downward_api_volume_file.dart';
part 'kubernetes/io_k8s_api_core_v1_http_get_action.dart';
part 'kubernetes/io_k8s_api_rbac_v1_cluster_role_binding_list.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_mutating_webhook.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_priority_level_configuration_list.dart';
part 'kubernetes/io_k8s_api_core_v1_service_account_token_projection.dart';
part 'kubernetes/io_k8s_api_core_v1_iscsi_persistent_volume_source.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_status_cause.dart';
part 'kubernetes/io_k8s_api_rbac_v1_subject.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_horizontal_pod_autoscaler_behavior.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_status.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_status_details.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_resource_policy_rule.dart';
part 'kubernetes/io_k8s_api_core_v1_ephemeral_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_namespace_spec.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_node.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_limit_range_list.dart';
part 'kubernetes/io_k8s_api_authorization_v1_non_resource_rule.dart';
part 'kubernetes/io_k8s_api_networking_v1alpha1_cluster_cidr.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition_spec.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_node_resources.dart';
part 'kubernetes/io_k8s_api_certificates_v1_certificate_signing_request.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_managed_fields_entry.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_metric_identifier.dart';
part 'kubernetes/io_k8s_api_core_v1_ceph_fs_volume_source.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_attachment_status.dart';
part 'kubernetes/io_k8s_api_authorization_v1_self_subject_access_review_spec.dart';
part 'kubernetes/io_k8s_api_authentication_v1_bound_object_reference.dart';
part 'kubernetes/io_k8s_kube_aggregator_pkg_apis_apiregistration_v1_api_service_condition.dart';
part 'kubernetes/io_k8s_api_discovery_v1_endpoint_slice.dart';
part 'kubernetes/io_k8s_api_authentication_v1_token_request.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_template_spec.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_metric_value_status.dart';
part 'kubernetes/io_k8s_api_authentication_v1_token_review.dart';
part 'kubernetes/io_k8s_api_core_v1_component_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_queuing_configuration.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim_template.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_priority_level_configuration.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_node_list.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_non_resource_policy_rule.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_class_list.dart';
part 'kubernetes/io_k8s_api_certificates_v1_certificate_signing_request_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_photon_persistent_disk_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_ephemeral_container.dart';
part 'kubernetes/io_k8s_api_core_v1_downward_api_volume_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_resource_metric_status.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_hpa_scaling_policy.dart';
part 'kubernetes/io_k8s_api_core_v1_cinder_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_object_field_selector.dart';
part 'kubernetes/io_k8s_api_core_v1_probe.dart';
part 'kubernetes/io_k8s_api_networking_v1_ip_block.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_service_reference.dart';
part 'kubernetes/io_k8s_api_apps_v1_deployment_spec.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_external_documentation.dart';
part 'kubernetes/io_k8s_api_apps_v1_replica_set_status.dart';
part 'kubernetes/io_k8s_api_core_v1_fc_volume_source.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_user_subject.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_list.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim_status.dart';
part 'kubernetes/io_k8s_api_core_v1_resource_quota.dart';
part 'kubernetes/io_k8s_api_core_v1_volume_projection.dart';
part 'kubernetes/io_k8s_api_core_v1_host_alias.dart';
part 'kubernetes/io_k8s_api_events_v1_event.dart';
part 'kubernetes/io_k8s_api_core_v1_binding.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_validating_webhook.dart';
part 'kubernetes/io_k8s_api_core_v1_event_source.dart';
part 'kubernetes/io_k8s_api_apps_v1_daemon_set.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_egress_rule.dart';
part 'kubernetes/io_k8s_api_core_v1_weighted_pod_affinity_term.dart';
part 'kubernetes/io_k8s_api_core_v1_azure_file_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_dns_config_option.dart';
part 'kubernetes/io_k8s_api_core_v1_exec_action.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map_volume_source.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_group_subject.dart';
part 'kubernetes/io_k8s_api_core_v1_node_selector.dart';
part 'kubernetes/io_k8s_api_core_v1_replication_controller.dart';
part 'kubernetes/io_k8s_kube_aggregator_pkg_apis_apiregistration_v1_api_service_spec.dart';
part 'kubernetes/io_k8s_api_certificates_v1_certificate_signing_request_status.dart';
part 'kubernetes/io_k8s_api_authorization_v1_non_resource_attributes.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_object_metric_status.dart';
part 'kubernetes/io_k8s_api_storage_v1_token_request.dart';
part 'kubernetes/io_k8s_api_networking_v1_http_ingress_path.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_group_subject.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_object_meta.dart';
part 'kubernetes/io_k8s_api_core_v1_container_port.dart';
part 'kubernetes/io_k8s_api_core_v1_lifecycle_handler.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_anti_affinity.dart';
part 'kubernetes/io_k8s_api_apps_v1_rolling_update_daemon_set.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_rule.dart';
part 'kubernetes/io_k8s_api_core_v1_local_volume_source.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_flow_schema_list.dart';
part 'kubernetes/io_k8s_api_core_v1_node_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_priority_level_configuration_condition.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_api_group.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_glusterfs_volume_source.dart';
part 'kubernetes/io_k8s_api_networking_v1_http_ingress_rule_value.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_flow_schema_spec.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_node_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map_key_selector.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_affinity.dart';
part 'kubernetes/io_k8s_api_core_v1_topology_selector_label_requirement.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_subresources.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_pods_metric_source.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_dns_config.dart';
part 'kubernetes/io_k8s_api_core_v1_limit_range.dart';
part 'kubernetes/io_k8s_api_core_v1_secret_key_selector.dart';
part 'kubernetes/io_k8s_api_core_v1_container_state.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_api_resource_list.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_metric_target.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_column_definition.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_status.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_resource_metric_source.dart';
part 'kubernetes/io_k8s_api_core_v1_container_state_waiting.dart';
part 'kubernetes/io_k8s_api_storage_v1beta1_csi_storage_capacity.dart';
part 'kubernetes/io_k8s_api_core_v1_volume_device.dart';
part 'kubernetes/io_k8s_api_core_v1_service_account_list.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_rule_with_operations.dart';
part 'kubernetes/io_k8s_api_core_v1_gce_persistent_disk_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_node_affinity.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_peer.dart';
part 'kubernetes/io_k8s_api_node_v1_overhead.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_policy_rules_with_subjects.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_limited_priority_level_configuration.dart';
part 'kubernetes/io_k8s_api_core_v1_secret_env_source.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set_status.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_pods_metric_status.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_validation_rule.dart';
part 'kubernetes/io_k8s_api_rbac_v1_aggregation_rule.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_object_metric_status.dart';
part 'kubernetes/io_k8s_api_scheduling_v1_priority_class_list.dart';
part 'kubernetes/io_k8s_api_core_v1_node_config_source.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_status.dart';
part 'kubernetes/io_k8s_api_core_v1_quobyte_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_resource_field_selector.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_priority_level_configuration_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_local_object_reference.dart';
part 'kubernetes/io_k8s_api_apps_v1_replica_set_spec.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_validating_webhook_configuration_list.dart';
part 'kubernetes/io_k8s_api_core_v1_lifecycle.dart';
part 'kubernetes/io_k8s_api_core_v1_flex_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_batch_v1_job_spec.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_flow_schema_condition.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_validating_webhook_configuration.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition_status.dart';
part 'kubernetes/io_k8s_api_apiserverinternal_v1alpha1_storage_version_list.dart';
part 'kubernetes/io_k8s_api_apiserverinternal_v1alpha1_server_storage_version.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition_names.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_scale.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_horizontal_pod_autoscaler_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_service_account.dart';
part 'kubernetes/io_k8s_api_apps_v1_deployment_strategy.dart';
part 'kubernetes/io_k8s_api_authorization_v1_self_subject_rules_review.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_service_reference.dart';
part 'kubernetes/io_k8s_api_core_v1_capabilities.dart';
part 'kubernetes/io_k8s_api_authorization_v1_resource_attributes.dart';
part 'kubernetes/io_k8s_api_core_v1_service_status.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map.dart';
part 'kubernetes/io_k8s_api_core_v1_node_daemon_endpoints.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_driver.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_metric_identifier.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_attachment_list.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_priority_level_configuration_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_node_address.dart';
part 'kubernetes/io_k8s_api_core_v1_pod.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_external_metric_status.dart';
part 'kubernetes/io_k8s_api_authorization_v1_subject_access_review.dart';
part 'kubernetes/io_k8s_api_core_v1_aws_elastic_block_store_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_env_var.dart';
part 'kubernetes/io_k8s_api_admissionregistration_v1_webhook_client_config.dart';
part 'kubernetes/io_k8s_api_core_v1_persistent_volume_claim_condition.dart';
part 'kubernetes/io_k8s_api_core_v1_replication_controller_list.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_status.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_flow_schema.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set_list.dart';
part 'kubernetes/io_k8s_api_batch_v1_uncounted_terminated_pods.dart';
part 'kubernetes/io_k8s_api_apps_v1_replica_set.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_subject.dart';
part 'kubernetes/io_k8s_api_authorization_v1_local_subject_access_review.dart';
part 'kubernetes/io_k8s_api_apps_v1_deployment.dart';
part 'kubernetes/io_k8s_api_core_v1_namespace_status.dart';
part 'kubernetes/io_k8s_api_core_v1_storage_os_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_priority_level_configuration_spec.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_policy_rules_with_subjects.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_condition.dart';
part 'kubernetes/io_k8s_api_apps_v1_daemon_set_status.dart';
part 'kubernetes/io_k8s_api_core_v1_topology_selector_term.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_container_resource_metric_status.dart';
part 'kubernetes/io_k8s_api_rbac_v1_role.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set.dart';
part 'kubernetes/io_k8s_api_batch_v1_cron_job_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_taint.dart';
part 'kubernetes/io_k8s_api_core_v1_daemon_endpoint.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_readiness_gate.dart';
part 'kubernetes/io_k8s_api_core_v1_azure_disk_volume_source.dart';
part 'kubernetes/io_k8s_api_policy_v1_pod_disruption_budget_status.dart';
part 'kubernetes/io_k8s_api_networking_v1alpha1_cluster_cidr_list.dart';
part 'kubernetes/io_k8s_api_core_v1_toleration.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_label_selector.dart';
part 'kubernetes/io_k8s_api_core_v1_nfs_volume_source.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_api_group_list.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_scope_selector.dart';
part 'kubernetes/io_k8s_api_networking_v1_network_policy.dart';
part 'kubernetes/io_k8s_api_core_v1_load_balancer_ingress.dart';
part 'kubernetes/io_k8s_api_apps_v1_rolling_update_deployment.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_api_versions.dart';
part 'kubernetes/io_k8s_api_authentication_v1_token_review_spec.dart';
part 'kubernetes/io_k8s_api_scheduling_v1_priority_class.dart';
part 'kubernetes/io_k8s_api_core_v1_node_selector_term.dart';
part 'kubernetes/io_k8s_api_core_v1_service_port.dart';
part 'kubernetes/io_k8s_api_core_v1_object_reference.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_horizontal_pod_autoscaler_status.dart';
part 'kubernetes/io_k8s_api_core_v1_ceph_fs_persistent_volume_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_horizontal_pod_autoscaler.dart';
part 'kubernetes/io_k8s_api_core_v1_affinity.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_container_resource_metric_source.dart';
part 'kubernetes/io_k8s_api_core_v1_scale_io_volume_source.dart';
part 'kubernetes/io_k8s_api_core_v1_replication_controller_status.dart';
part 'kubernetes/io_k8s_api_node_v1_runtime_class_list.dart';
part 'kubernetes/io_k8s_api_core_v1_resource_quota_spec.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_horizontal_pod_autoscaler_status.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress.dart';
part 'kubernetes/io_k8s_api_batch_v1_job_template_spec.dart';
part 'kubernetes/io_k8s_api_certificates_v1_certificate_signing_request_list.dart';
part 'kubernetes/io_k8s_api_core_v1_volume.dart';
part 'kubernetes/io_k8s_api_authorization_v1_subject_rules_review_status.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map_node_config_source.dart';
part 'kubernetes/io_k8s_api_autoscaling_v1_horizontal_pod_autoscaler_spec.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_driver_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_service.dart';
part 'kubernetes/io_k8s_api_apps_v1_daemon_set_list.dart';
part 'kubernetes/io_k8s_api_rbac_v1_cluster_role_list.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_class_parameters_reference.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_external_metric_source.dart';
part 'kubernetes/io_k8s_api_core_v1_endpoint_port.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_list.dart';
part 'kubernetes/io_k8s_api_apps_v1_daemon_set_update_strategy.dart';
part 'kubernetes/io_k8s_api_node_v1_runtime_class.dart';
part 'kubernetes/io_k8s_api_core_v1_config_map_projection.dart';
part 'kubernetes/io_k8s_api_storage_v1_volume_attachment.dart';
part 'kubernetes/io_k8s_api_policy_v1_pod_disruption_budget_list.dart';
part 'kubernetes/io_k8s_api_storage_v1_csi_storage_capacity.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_priority_level_configuration.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta1_user_subject.dart';
part 'kubernetes/io_k8s_api_coordination_v1_lease_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_endpoint_address.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_ip.dart';
part 'kubernetes/io_k8s_api_flowcontrol_v1beta2_flow_distinguisher_method.dart';
part 'kubernetes/io_k8s_api_apps_v1_stateful_set_update_strategy.dart';
part 'kubernetes/io_k8s_api_rbac_v1_policy_rule.dart';
part 'kubernetes/io_k8s_api_authorization_v1_self_subject_rules_review_spec.dart';
part 'kubernetes/io_k8s_api_core_v1_volume_node_affinity.dart';
part 'kubernetes/io_k8s_api_core_v1_seccomp_profile.dart';
part 'kubernetes/io_k8s_api_core_v1_pod_template.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_metric_spec.dart';
part 'kubernetes/io_k8s_api_batch_v1_pod_failure_policy_on_exit_codes_requirement.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2beta2_horizontal_pod_autoscaler_spec.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_preconditions.dart';
part 'kubernetes/io_k8s_api_core_v1_service_list.dart';
part 'kubernetes/io_k8s_api_core_v1_http_header.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_metric_target.dart';
part 'kubernetes/io_k8s_apimachinery_pkg_apis_meta_v1_server_address_by_client_cidr.dart';
part 'kubernetes/io_k8s_apiextensions_apiserver_pkg_apis_apiextensions_v1_custom_resource_definition_version.dart';
part 'kubernetes/io_k8s_api_authentication_v1_token_review_status.dart';
part 'kubernetes/io_k8s_api_apiserverinternal_v1alpha1_storage_version.dart';
part 'kubernetes/io_k8s_api_autoscaling_v2_horizontal_pod_autoscaler_behavior.dart';
part 'kubernetes/io_k8s_api_rbac_v1_role_binding_list.dart';
part 'kubernetes/io_k8s_api_networking_v1_ingress_service_backend.dart';
part 'kubernetes/io_k8s_api_core_v1_grpc_action.dart';
part 'kubernetes/io_k8s_kube_aggregator_pkg_apis_apiregistration_v1_service_reference.dart';
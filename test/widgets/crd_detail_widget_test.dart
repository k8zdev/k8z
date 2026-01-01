import 'package:flutter_test/flutter_test.dart';
import 'package:k8zdev/widgets/detail_widgets/crd.dart';
import 'package:k8zdev/models/models.dart';

void main() {
  group('buildCrdDetailSectionTiles', () {
    test('generates tiles for namespaced CRD', () {
      final crd = IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinition(
        apiVersion: 'apiextensions.k8s.io/v1',
        kind: 'CustomResourceDefinition',
        spec: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionSpec(
          group: 'monitoring.coreos.com',
          names: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionNames(
            kind: 'Prometheus',
            plural: 'prometheuses',
            shortNames: ['prom'],
            singular: 'prometheus',
            categories: ['all'],
          ),
          scope: 'Namespaced',
          versions: [
            IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionVersion(
              name: 'v1',
              served: true,
              storage: true,
            ),
          ],
        ),
        status: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionStatus(
          storedVersions: ['v1'],
        ),
      );

      // Create a minimal mock context
      final tiles = buildCrdDetailSectionTiles(null, crd, 'en');

      expect(tiles, isNotEmpty);
      // Should have tiles for group, scope, kind, plural, singular, shortNames, categories, storage version, and versions
      expect(tiles.length, greaterThanOrEqualTo(5));
    });

    test('generates tiles for cluster-scoped CRD', () {
      final crd = IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinition(
        apiVersion: 'apiextensions.k8s.io/v1',
        kind: 'CustomResourceDefinition',
        spec: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionSpec(
          group: 'cert-manager.io',
          names: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionNames(
            kind: 'Certificate',
            plural: 'certificates',
            shortNames: ['cert', 'certs'],
            singular: 'certificate',
            categories: ['all'],
          ),
          scope: 'Cluster',
          versions: [
            IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionVersion(
              name: 'v1',
              served: true,
              storage: true,
            ),
          ],
        ),
        status: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionStatus(
          storedVersions: ['v1'],
        ),
      );

      final tiles = buildCrdDetailSectionTiles(null, crd, 'en');

      expect(tiles, isNotEmpty);
      expect(tiles.length, greaterThanOrEqualTo(5));
    });

    test('handles CRD with storage version correctly', () {
      final crd = IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinition(
        apiVersion: 'apiextensions.k8s.io/v1',
        kind: 'CustomResourceDefinition',
        spec: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionSpec(
          group: 'monitoring.coreos.com',
          names: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionNames(
            kind: 'Prometheus',
            plural: 'prometheuses',
            shortNames: ['prom'],
          ),
          scope: 'Namespaced',
          versions: [
            IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionVersion(
              name: 'v1alpha1',
              served: false,
              storage: false,
            ),
            IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionVersion(
              name: 'v1',
              served: true,
              storage: true,
            ),
          ],
        ),
        status: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionStatus(
          storedVersions: ['v1alpha1', 'v1'],
        ),
      );

      final tiles = buildCrdDetailSectionTiles(null, crd, 'en');

      expect(tiles, isNotEmpty);
      // Should have more tiles due to stored versions
      expect(tiles.length, greaterThanOrEqualTo(6));
    });

    test('handles empty shortNames list correctly', () {
      final crd = IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinition(
        apiVersion: 'apiextensions.k8s.io/v1',
        kind: 'CustomResourceDefinition',
        spec: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionSpec(
          group: 'example.com',
          names: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionNames(
            kind: 'Example',
            plural: 'examples',
            shortNames: [],
          ),
          scope: 'Namespaced',
          versions: [],
        ),
      );

      final tiles = buildCrdDetailSectionTiles(null, crd, 'en');

      expect(tiles, isNotEmpty);
      // Should not crash when shortNames is empty
      expect(tiles.length, greaterThan(0));
    });

    test('handles missing status field correctly', () {
      final crd = IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinition(
        apiVersion: 'apiextensions.k8s.io/v1',
        kind: 'CustomResourceDefinition',
        spec: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionSpec(
          group: 'example.com',
          names: IoK8sApiextensionsApiserverPkgApisApiextensionsV1CustomResourceDefinitionNames(
            kind: 'Example',
            plural: 'examples',
          ),
          scope: 'Namespaced',
          versions: [],
        ),
        status: null,
      );

      final tiles = buildCrdDetailSectionTiles(null, crd, 'en');

      expect(tiles, isNotEmpty);
      // Should not crash when status is null
      expect(tiles.length, greaterThan(0));
    });

    test('returns empty tile when CRD is null', () {
      final tiles = buildCrdDetailSectionTiles(null, null, 'en');

      expect(tiles, isNotEmpty);
      expect(tiles.length, equals(1));
    });
  });
}

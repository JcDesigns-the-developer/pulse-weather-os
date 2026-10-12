# wxcore

The first shared Pulse Weather OS code package defines normalized, provenance-aware weather data records. It has no external dependencies and is intended to be used by provider adapters, analysis services, and desktop apps.

Run its unit tests from the repository root:

    PYTHONPATH=packages/wxcore python3 -m unittest discover -s packages/wxcore/tests -v

The record envelope separates official products, observations, model guidance, analyst content, and experimental output. It requires timezone-aware timestamps and an explicit coordinate reference system when geometry is supplied. It does not fetch or generate weather data by itself.

# Check-in OU Client (Flutter 3.x)

Cliente multiplataforma (Web/PWA, Android e Desktop) com estratégia **offline-first**.

## Arquitetura

```text
lib/
  core/
  data/
  domain/
  presentation/
```

- **Estado**: Riverpod
- **HTTP**: Dio + Interceptor para fila offline
- **DB local**: Drift (`LocalStudentForms`, `LocalTripHistory`, `SyncQueue`)
- **Scan/QR**: `mobile_scanner` e `qr_flutter`

## Fluxo offline

1. Requisições mutáveis falham por falta de rede.
2. `SyncInterceptor` serializa e salva na tabela `SyncQueue`.
3. `SyncService` observa conectividade e reenfileira em FIFO.
4. Em conflito `409`, remove o item para evitar loop.

## Como rodar

```bash
cd flutter_client
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

> API base URL padrão: `http://localhost:8000` (ajuste em `ApiClient`).

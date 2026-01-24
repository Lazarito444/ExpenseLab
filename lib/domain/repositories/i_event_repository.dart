abstract class IEventRepository {
  Future<void> recordEvent({
    required String aggregateId,
    required String eventType,
    required Map<String, dynamic> payload,
  });
}

trigger BatchApexErrorEventTrigger on BatchApexErrorEvent (after insert) {
	BatchApexErrorHelper.handleBatchErrorEvents(Trigger.New);
}
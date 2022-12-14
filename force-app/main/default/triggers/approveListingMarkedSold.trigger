trigger approveListingMarkedSold on pba__Listing__c (after update) {
	 /*for (pba__Listing__c listing :  Trigger.new) {

        if (listing.Property_Status__c == 'Sold' ) {
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments('Offer Submitted for approval');
            approvalRequest.setObjectId(listing.Id);
            Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
            System.debug('offer submitted for approval successfully: '+approvalResult .isSuccess());

        }

    }*/
}
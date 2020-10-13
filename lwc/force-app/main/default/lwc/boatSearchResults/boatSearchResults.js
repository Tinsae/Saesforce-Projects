import { LightningElement, api, wire, track } from 'lwc';
// Import message service features required for publishing and the message channel
import { publish, MessageContext } from 'lightning/messageService';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';

import getBoats from '@salesforce/apex/BoatDataService.getBoats';

import NAME_FIELD from '@salesforce/schema/Boat__c.Name';
import LENGTH_FIELD from '@salesforce/schema/Boat__c.Length__c';
import PRICE_FIELD from '@salesforce/schema/Boat__c.Price__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Boat__c.Description__c';

import { updateRecord, getRecord } from 'lightning/uiRecordApi';

import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { refreshApex } from '@salesforce/apex';

// ...
const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT = 'Ship it!';
const SUCCESS_VARIANT = 'success';
const ERROR_TITLE = 'Error';
const ERROR_VARIANT = 'error';

// const COLUMNS = [
//   {label: 'Name' , fieldName:'Name' , type: 'text',editable:"true"},
//   {label: 'Length', fieldName: 'Length__c', type: 'number',editable:"true"},
//   {label: 'Price', fieldName: 'Price__c', type: 'currency',editable:"true"},
//   {label: 'Description', fieldName: 'Description__c', type: 'text',editable:"true"},
// ];
const COLUMNS = [
  { label: 'Name', fieldName: NAME_FIELD.fieldApiName, type: 'text', editable: true },
  { label: 'Length', fieldName: LENGTH_FIELD.fieldApiName, type: 'number', editable: true },
  { label: 'Price', fieldName: PRICE_FIELD.fieldApiName, type: 'currency', editable: true },
  { label: 'Description', fieldName: DESCRIPTION_FIELD.fieldApiName, type: 'text', editable: true }
];
export default class BoatSearchResults extends LightningElement {
  // columns = [
  //   { label: 'Name', fieldName: NAME_FIELD.fieldApiName, type: 'text', editable: true },
  //   { label: 'Length', fieldName: LENGTH_FIELD.fieldApiName, type: 'number', editable: true },
  //   { label: 'Price', fieldName: PRICE_FIELD.fieldApiName, type: 'currency', editable: true },
  //   { label: 'Description', fieldName: DESCRIPTION_FIELD.fieldApiName, type: 'text', editable: true }
  // ];
  columns = COLUMNS;
  @api boatTypeId = '';
  @track selectedBoatId;
  @track boats;
  boatsRefresh;
  isLoading = false;
  @track draftValues = [];


  // wired message context
  @wire(MessageContext)
  messageContext;
  // wired getBoats method
  @wire(getBoats, { boatTypeId: '$boatTypeId' })
  wiredBoats(result) {
    this.boatsRefresh = result;
    if (this.boatsRefresh.data) {
      this.boats = this.boatsRefresh.data;
    }
  }

  // public function that updates the existing boatTypeId property
  // uses notifyLoading
  @api
  searchBoats(boatTypeId) {
    this.notifyLoading(true);
    this.boatTypeId = boatTypeId;
    this.notifyLoading(false);
  }

  // this public function must refresh the boats asynchronously
  // uses notifyLoading
  @api
  async refresh() {
    this.notifyLoading(true);
    await refreshApex(this.boatsRefresh);
    this.notifyLoading(false);
  }

  // this function must update selectedBoatId and call sendMessageService
  updateSelectedTile(event) {
    this.selectedBoatId = event.detail.boatId;
    this.sendMessageService(this.selectedBoatId);
  }

  // Publishes the selected boat Id on the BoatMC.
  sendMessageService(boatId) {
    // explicitly pass boatId to the parameter recordId
    const payload = { recordId: boatId };
    publish(this.messageContext, BOATMC, payload);
  }

  // This method must save the changes in the Boat Editor
  // Show a toast message with the title
  // clear lightning-datatable draft values
  handleSave(event) {
    this.notifyLoading(true);
    const recordInputs = event.detail.draftValues.slice().map(draft => {
      const fields = Object.assign({}, draft);
      return { fields };
    });
    const promises = recordInputs.map(recordInput => updateRecord(recordInput));
    Promise.all(promises)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: SUCCESS_TITLE,
            message: MESSAGE_SHIP_IT,
            variant: SUCCESS_VARIANT
          })
        );
        this.draftValues = [];
        return this.refresh();
      })
      .catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: ERROR_TITLE,
            message: error,
            variant: ERROR_VARIANT
          })
        );
        this.notifyLoading(false);
      })
      .finally(() => {
        this.draftValues = [];
      });
  }
  // Check the current value of isLoading before dispatching the doneloading or loading custom event
  notifyLoading(isLoading) {
    this.isLoading = isLoading;
    if (this.isLoading) {
      this.dispatchEvent(new CustomEvent("loading"));
    }
    else {
      this.dispatchEvent(new CustomEvent("doneloading"));
    }
  }
}
import { LightningElement } from 'lwc';
import logo from '@salesforce/resourceUrl/logo';
import isGuest from '@salesforce/user/isGuest';

export default class Header extends LightningElement {
    imageUrl = logo;

    isNotGuest = !isGuest;
    isguest = isGuest;
}
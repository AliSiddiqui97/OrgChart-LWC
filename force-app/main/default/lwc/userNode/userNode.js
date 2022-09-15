import { LightningElement, wire, api } from 'lwc';
import getUserList from '@salesforce/apex/getUsers.getUserList' 

export default class UserNode extends LightningElement {

    @api fullName
    user = {
        id:'',
        firstName:'',
        lastName:'',
        reportsTo:'',
        name:'',
        role:'',
        managerOf:[],
         
    }
    get hasChilds(){
        console.log('childs ' + this.user.managerOf.length)
        return this.user.managerOf.length > 0
    }
    handleData(data){
        console.log('Data rec:: > '+ JSON.stringify(data))
        this.user = data;
    }
    handleError(err){
        console.log('Error ::> '+JSON.stringify(err));
    }

    @wire(getUserList,{fullName: '$fullName'})
    userList({data,error}){
        if(data){
            this.handleData(data);
        }
        else if(error){
            this.handleError(error);
        }
    }

}
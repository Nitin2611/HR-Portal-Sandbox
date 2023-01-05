import {
    LightningElement,
    track,
    api
} from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import ques from './questions.html';
import ls from './languageselection.html';
import qp from './questionspage.html';
import tp from './thankyou.html';
import qc from '@salesforce/resourceUrl/questioncss';
import getQues from '@salesforce/apex/QuestionsController.getQuestions';
import creCon from '@salesforce/apex/QuestionsController.createContact';
import saveAns from '@salesforce/apex/QuestionsController.saveAnswers';


export default class Questions extends LightningElement {
    @track showspinner = false;
    @track displayOptionA = ques;
    // @track displayOptionA = tp;
    regContactForm = {};  

    question1 = '';
    question2 = '';
    question3 = '';
    question4 = '';
    question5 = '';
    question6 = '';

    @track answer1 = '';
    @track answer2 = '';
    @track answer3 = '';
    @track answer4 = '';
    @track answer5 = '';
    @track answer6 = '';

    // @track timertext = 'Loading!!';
    // timerinterval;
    // @track countDownDate;
    timer = '0'
    timerRef

    firstname='';
    lastname='';
    email='';
    enroll='';

    answerId = '';

    contactId = '';
    errormsg;

    @track submitdisable = true;
    @track langdisable = true;

    @track confirm = false;
    selectedlanguages = [];
    showlanguages = '';
    render() {
        //If displayOptionA is true return optionA template
        // return this.displayOptionA ? ques : ls;
        return this.displayOptionA;
    }

    nextfromlanguage(event){
        console.log('next');
        // debugger;
        var checkboxlist = this.template.querySelectorAll('input[type="checkbox"]:checked');
        console.log({checkboxlist})
        console.log('checkboxlist==>',checkboxlist.length)
        if(checkboxlist.length > 1){
            this.selectedlanguages = [];
            this.showlanguages = '';
            for(var s of checkboxlist){
                this.selectedlanguages.push(s.value);
                this.showlanguages += s.name + ', ';
            }
            this.showlanguages = this.showlanguages.slice(0,this.showlanguages.length - 2);
            this.confirm = true;
        }else{
            this.errormsg = 'Please Select atleast 2 value!';
        }
    }

    closepopup(){
        this.confirm = false;
    }

    gotoquestions() {
        this.showspinner = true;
        getQues({
                langlist: this.selectedlanguages,
                contactId: this.contactId
            })
            .then(result => {
                console.log({
                    result
                });
                var ql = result.quelist;
                console.log({
                    ql
                });
                if (ql.length == 1) {
                    this.question1 = ql[0].Question__c;
                } else if (ql.length == 2) {
                    this.question1 = ql[0].Question__c;
                    this.question2 = ql[1].Question__c;
                }else if(ql.length == 3){
                    this.question1 = ql[0].Question__c;
                    this.question2 = ql[1].Question__c;
                    this.question3 = ql[2].Question__c;
                }else if(ql.length == 4){
                    this.question1 = ql[0].Question__c;
                    this.question2 = ql[1].Question__c;
                    this.question3 = ql[2].Question__c;
                    this.question4 = ql[3].Question__c;
                }else if(ql.length == 5){
                    this.question1 = ql[0].Question__c;
                    this.question2 = ql[1].Question__c;
                    this.question3 = ql[2].Question__c;
                    this.question4 = ql[3].Question__c;
                    this.question5 = ql[4].Question__c;
                }else if(ql.length == 6){
                    this.question1 = ql[0].Question__c;
                    this.question2 = ql[1].Question__c;
                    this.question3 = ql[2].Question__c;
                    this.question4 = ql[3].Question__c;
                    this.question5 = ql[4].Question__c;
                    this.question6 = ql[5].Question__c;
                }
                this.answerId = result.ansId;


                // const startTime = new Date(window.localStorage.getItem("startTimer") || this.StartTimerHandler())
                const startTime = new Date().getTime() + (45 * 60000);
                this.timerRef = window.setInterval(() => {
                    const secsDiff = startTime - new Date().getTime();
                    this.timer = this.secondToHms(Math.floor(secsDiff / 1000))
                    if (secsDiff < 0) {
                        clearInterval(this.timerRef);
                    }
                }, 1000)
                this.showspinner = false;
                this.displayOptionA = qp;
            })
            .catch(error => {
                this.showspinner = false;
                console.log({
                    error
                });
                alert('Something went wrong. Contact your interviewer.');
            });
    }

    secondToHms(d){
        d = Number(d)
        const h = Math.floor(d / 3600);
        const m = Math.floor(d % 3600 / 60);
        const s = Math.floor(d % 3600 % 60);
        const hDisplay = h > 0 ? h + (h == 1 ? " hour, " : " hours, ") : "";
        const mDisplay = m > 0 ? m + (m == 1 ? " minute, " : " minutes, ") : "";
        const sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
        return hDisplay + mDisplay + sDisplay; 
    }

    connectedCallback() {
        
    }

    // submitanswerdetails(event){
    //     this.showspinner = true;
    //     console.log(this.answer1);
    //     console.log(this.answer2);
    //     saveAns({
    //         answer1 : this.answer1,
    //         answer2 : this.answer2,
    //         ansId : this.answerId
    //     })
    //     .then(result => {
    //         console.log({result});
    //         this.showspinner = false;
    //         this.displayOptionA = tp;
    //     })
    //     .catch(error=>{
    //         this.showspinner = false;
    //         console.log({error});
    //         alert('Something went wrong. Contact your interviewer');
    //     })
    // }

    // submituserdetails(event) {
    //     this.showspinner = true;
    //     creCon({
    //         firstname : this.firstname,
    //         lastname : this.lastname,
    //         email : this.email,
    //         enroll : this.enroll
    //     })
    //     .then(result => {
    //         console.log({result})
    //         this.contactId = result;
    //         this.showspinner = false;
    //         this.displayOptionA = ls;
    //     })
    //     .catch(error => {
    //         this.showspinner = false;
    //         console.log({error});
    //         alert('Something went wrong. Contact your interviewer.');
    //     });
    // }

    
    
    regInpFormAction() {
        var isValidVal = true;
        var inputFields = this.template.querySelectorAll('.reqInpFld');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValidVal = false;
            }
            this.regContactForm[inputField.name] = inputField.value;
        });
        return isValidVal;
    }
    
 
    submituserdetails() {
        if(this.regInpFormAction()) {            
            var inputFields = this.template.querySelectorAll('.reqInpFld');
            inputFields.forEach(inputField => {               
                inputField.value="";
            });
            this.showspinner = true;
            creCon({
                firstname : this.firstname,
                lastname : this.lastname,
                email : this.email,
                enroll : this.enroll
            })
            .then(result => {
                console.log({result})
                this.contactId = result;
                this.showspinner = false;
                this.displayOptionA = ls;
            })
            .catch(error => {
                this.showspinner = false;
                console.log({error});
                alert('Something went wrong. Contact your interviewer.');
            });
        }
        
    }

    submitanswerdetails(){
        if(this.regInpFormAction()) {      
            var inputFields = this.template.querySelectorAll('.reqInpFld');
            inputFields.forEach(inputField => {               
                inputField.value="";
            });
            this.showspinner = true;
            console.log(this.answer1);
            console.log(this.answer2);
            console.log(this.answer3);
            console.log(this.answer4);
            console.log(this.answer5);
            console.log(this.answer6);
            saveAns({
                answer1 : this.answer1,
                answer2 : this.answer2,
                answer3 : this.answer3,
                answer4 : this.answer4,
                answer5 : this.answer5,
                answer6 : this.answer6,
                ansId : this.answerId
            })
            .then(result => {
                console.log({result});
                this.showspinner = false;
                this.displayOptionA = tp;
            })
            .catch(error=>{
                this.showspinner = false;
                console.log({error});
                alert('Something went wrong. Contact your interviewer');
            })
        }
    }


    renderedCallback() {
        Promise.all([
            loadStyle(this, qc)
        ]).then(() => {
            console.log('css loaded');
        })
        .catch(error => {   
            console.log({error});
            
        });
    }

    handleChange(event){
        const field = event.target.name;
        var value = event.target.value;

        if(field == "firstname"){
            this.firstname = value;
        }else if(field == "lastname"){
            this.lastname = value;
        }else if(field == "email"){
            this.email = value;
        }else if(field == "enroll"){
            this.enroll = value;
        }else if(field == "answer1"){
            this.answer1 = value;
        }else if(field == "answer2"){
            this.answer2 = value;
        }else if(field == "answer3"){
            this.answer3 = value;
        }else if(field == "answer4"){
            this.answer4 = value;
        }else if(field == "answer5"){
            this.answer5 = value;
        }else if(field == "answer6"){
            this.answer6 = value;
        }

        this.inputvalue = [...this.template.querySelectorAll('input,lightning-textarea')].reduce((validSoFar, inputField) => {
            return validSoFar && inputField.checkValidity();
        }, true);

        if(this.inputvalue){
            this.submitdisable = false;
        }else{
            this.submitdisable = true;
        }

        console.log('-->'+this.inputvalue);
    }

    checkboxchange(event){
        var checkboxlist = this.template.querySelectorAll('input[type="checkbox"]:checked');
        if(checkboxlist.length == 2){
            var unchecked = this.template.querySelectorAll('input[type="checkbox"]:not(:checked)');
            for(var s of unchecked){
                s.disabled = true;
            }
            // this.checkboxdisable ==
        }else if(checkboxlist.length < 2){
            var unchecked = this.template.querySelectorAll('input[type="checkbox"]');
            for(var s of unchecked){
                s.disabled = false;
            }
        }

        if(checkboxlist.length == 0){
            this.langdisable = true;
        }else{
            this.langdisable = false;
        }
    }
}
/**
 * Class containing tests for ServiceRequestController
 */
 @IsTest
 public with sharing class ServiceRequestControllerTest { 
      private static contact cont;
      private static ServiceRequestType__c serviceType1;
      private static case caseRrd;
      private static list<case> caseRrdList;
      private static list<FlexNoteQuestion__c> flexNoteQuestList;
      private static list<FlexNote__c>AnswersList;
      private static list<ServiceRequestTypeFlexNote__c>sRTypeJunc;   
    
      private static ServiceRequestType__c getSRType(string SRTypeCode){
          ServiceRequestType__c sRT=new ServiceRequestType__c(Name=SRTypeCode,Object__c='Case',Service_Name__c='Abandoned Vehicle- On Private Property',Default_Status__c='New',Default_Priority__c='Standard',Default_Method__c='Phone');
          insert sRT;       

          return sRT;
      }
      
      
      private static void createData(){
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         Contact con=new Contact(FirstName='Mars',LastName='bruno', email='testContact@abc.com',Phone='1234567890');
         insert con;
         cont=con;
        
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         ServiceRequestType__c sRT=new ServiceRequestType__c(Name='Test22112',Object__c='Case',Service_Name__c='Abandoned Vehicle- On Private Property',Default_Status__c='New',Default_Priority__c='Standard',Default_Method__c='Phone',ContactRequired__c=true,ServiceLocationRequired__c=true,SR_Alert_Message__c='Test Message');
         insert sRT;
         serviceType1=sRT;
        
         flexNoteQuestList=new list<FlexNoteQuestion__c>();
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         FlexNoteQuestion__c fNQuestion=new FlexNoteQuestion__c(Object_Name__c='Case',Questions__c='This is the test Question',Answer_Type__c='MultiPicklist' ,Name='Test1',AnswerValues__c='test1:a1,test2:a2');//,Answer_Values__c='test1:a1,test2:a2');//Question__c='This is the test Question'
         insert fnQuestion;
        
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         FlexNoteQuestion__c fNQuestion1=new FlexNoteQuestion__c(Object_Name__c='Case',Questions__c='This is the test',Answer_Type__c='Text' ,Name='Test2');//,Answer_Values__c='test1:a1,test2:a2');//,Question__c='This is the test'
         insert fnQuestion1;
        
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         FlexNoteQuestion__c fNQuestion2=new FlexNoteQuestion__c(Object_Name__c='Case',Questions__c='This is the test picklist',Answer_Type__c='Picklist' ,Name='Test3',AnswerValues__c='test1:a1,test2:a2');//,Answer_Values__c='test1:a1,test2:a2');//Question__c='This is the test picklist'
         insert fnQuestion2;
        
         flexNoteQuestList.add(fnQuestion);
         flexNoteQuestList.add(fnQuestion1);
         flexNoteQuestList.add(fnQuestion2);
        
         sRTypeJunc=new list<ServiceRequestTypeFlexNote__c>();
        
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         ServiceRequestTypeFlexNote__c sRTypeFNRelation=new ServiceRequestTypeFlexNote__c(Service_Request_Type__c=sRT.Id,FlexNote_Question__c=fnQuestion.Id,Order__c='1',IsRequired__c=true);
         insert sRTypeFNRelation;
        
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         ServiceRequestTypeFlexNote__c sRTypeFNRelation1=new ServiceRequestTypeFlexNote__c(Service_Request_Type__c=sRT.Id,FlexNote_Question__c=fNQuestion2.Id,Order__c='1');
         insert sRTypeFNRelation1;
        
         sRTypeJunc.add(sRTypeFNRelation);
         sRTypeJunc.add(sRTypeFNRelation1);        
        
         caseRrdList=new list<case>();
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         Case c=new Case(Origin='Phone',Status='New',ContactId=con.Id,SRType__c=sRT.Id);
         insert c;      
         caseRrd=c;
        
         caseRrdList.add(caseRrd);
        
         AnswersList=new list<FlexNote__c>();
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         FlexNote__c fn=new FlexNote__c(Case__c=c.Id,FlexNote_Question__c=fNQuestion.Id,Answer__c='test1:a1',Questions__c=fNQuestion.Questions__c);//Question__c=fNQuestion.Question__c //Is_Answer__c='test1:a1',
         insert fn;
         // THIS PART AS TO MOVE TO TESTHELPER CLASS
         FlexNote__c fn1=new FlexNote__c(Case__c=c.Id,FlexNote_Question__c=fNQuestion1.Id,Answer__c='test1:a1',Questions__c=fNQuestion.Questions__c);//,Is_Answer__c='test1:a1'..,Question__c=fNQuestion.Question__c,
         insert fn1;
        
         AnswersList.add(fn);
         AnswersList.add(fn1);        
        
    }
    
    
       public static ServiceRequestController controller = new ServiceRequestController();
      
        @isTest(SeeAllData=true) static void testgetServiceRequestItems() {
            system.assert(controller.options1.size()==0);
            //controller.getServiceRequestItems();
            controller.options1.add(new SelectOption('None','Please Select'));
            controller.getServiceRequestItems();
        }

       @isTest static void testperformAction() { 
            createData(); 
            ServiceRequestController.QuestionAnswerWrapper qAW=new ServiceRequestController.QuestionAnswerWrapper(flexNoteQuestList[0],sRTypeJunc[0]);
            ServiceRequestController.QuestionAnswerWrapper qAW1=new ServiceRequestController.QuestionAnswerWrapper(flexNoteQuestList[1],sRTypeJunc[1]);
            list<ServiceRequestController.QuestionAnswerWrapper> qAWList=new list<ServiceRequestController.QuestionAnswerWrapper>{qAW,qAW1};
            ServiceRequestController.ServiceRequestQuestionWrapper sRQW=new ServiceRequestController.ServiceRequestQuestionWrapper(serviceType1,qAWList);
            list<ServiceRequestController.ServiceRequestQuestionWrapper> sRQWList=new list<ServiceRequestController.ServiceRequestQuestionWrapper>();
            sRQWList.add(sRQW);           
            controller.ServiceLocationRequired = true;
            FlexNoteQuestion__c FlexNoteQuestion=new FlexNoteQuestion__c(Code__c='DOYHFO21',Answer_Type__c='Picklist',AnswerValues__c='xxxx',Name='Test11');
            insert FlexNoteQuestion;        
            controller.serviceType=null;         
           
            controller.performAction();
            controller.serviceType=getSRType('SR01ZZTT').Id;
           
            controller.serviceRequestQuestionWrapList=sRQWList;
            controller.performAction();            
            
       }      
       

       static testMethod void all_methods(){
            Test.StartTest();
            controller.getservicetype();
            
            controller.serviceType='Bulk collection';
            controller.setServiceType(controller.serviceType);
             
            controller.servicetype();
            controller.selectedlocationlist();            
            
            controller.seladressloc='';
            controller.service_info();
            
            controller.seladressloc='753 JACKSON PLACE NORTHEAST';
            controller.service_info();
            
            controller.contact_info();            
            controller.comment_attachement();
            controller.review_action_next();
            controller.review_action_finish();
            controller.Previous_service_location();
            controller.Previous_service_location1();
            controller.clickCommandLink();
            controller.StartOver();
            
            ServiceRequestController.serviceLocationWrap slw = new ServiceRequestController.serviceLocationWrap(); 
           
            Test.StopTest();
       }  
       
       static testMethod void doRenderInputText(){           
            Test.StartTest();
            
            controller.selAnswerValue='Other';
            controller.selIndex=1;
            controller.doRenderInputText();
            
            controller.selAnswerValue='';
            Integer selIndex= 0;
            controller.doRenderInputText();            
            
            Test.StopTest();   
       
       }
       
       
       static testMethod void service_location(){           
            Test.StartTest();
            controller.service_location();
            
            controller.street='753 jackson place northeast';
            controller.jstring='{"returnCodes":null,"details":"<STRONG>Normalized:</STRONG> 3100 NW STREET</br><STRONG>Parsed:</STRONG></br><EM>Address Number: </EM>3100</br><EM>Address Number Suffix: </EM></br><EM>Street Name: </EM>NW</br><EM>Street Type: </EM></br><EM>Quad: </EM></br><STRONG>Possible Standard Street Names: </STRONG></br>W,N</br>","returnDataset":{"Table1":[{"ADDRESS_ID":274821.0,"STATUS":"ACTIVE","FULLADDRESS":"3100 N STREET NW","ADDRNUM":3100.0,"ADDRNUMSUFFIX":null,"STNAME":"N","STREET_TYPE":"STREET","QUADRANT":"NW","CITY":"WASHINGTON","STATE":"DC","XCOORD":394674.32,"YCOORD":137648.32,"SSL":"1208    0060","ANC":"ANC 2E","PSA":"Police Service Area 206","WARD":"Ward 2","NBHD_ACTION":" ","CLUSTER_":"Cluster 4","POLDIST":"Police District - Second District","ROC":"NA","CENSUS_TRACT":"000100","VOTE_PRCNCT":"Precinct 5","SMD":"SMD 2E05","ZIPCODE":20007.0,"NATIONALGRID":"18S UJ 21257 08441","ROADWAYSEGID":4625.0,"FOCUS_IMPROVEMENT_AREA":"NA","HAS_ALIAS":"N","HAS_CONDO_UNIT":"Y","HAS_RES_UNIT":"Y","HAS_SSL":"Y","LATITUDE":38.90667757,"LONGITUDE":-77.06140122,"STREETVIEWURL":"http://maps.google.com/maps?z=16&layer=c&cbll=38.90667757,-77.06140122&cbp=11,161.229197394201,,0,2.09","RES_TYPE":"RESIDENTIAL","WARD_2002":"Ward 2","WARD_2012":"Ward 2","ANC_2002":"ANC 2E","ANC_2012":"ANC 2E","SMD_2002":"SMD 2E06","SMD_2012":"SMD 2E05","IMAGEURL":"http://citizenatlas.dc.gov/mobilevideo","IMAGEDIR":"20040803","IMAGENAME":"E3064022.jpg","ConfidenceLevel":70.0}]},"returnBlkAddrDataset":null,"returnCDDataSet":{"Address Return Codes":[{"Component":"Street Type","Parsed & Normalized":"","Assessment":"Missing"},{"Component":"Quad","Parsed & Normalized":"","Assessment":"Missing"},{"Component":"Street Name","Parsed & Normalized":"NW","Assessment":"Not Valid"}]},"UNIT":null,"UNITNUMBER":null,"sourceOperation":"DC Address","processTime":"0 seconds and 343 milliseconds"}';            
            controller.length=1;
            controller.service_location(); 
            
            controller.jstring='{"returnCodes":"811","details":null,"returnDataset":{"Table1":[{"ALIASNAME":"1001 @ WATERFRONT APARTMENTS","ADDRESS_ID":76172.0,"STATUS":"ACTIVE","FULLADDRESS":"1001 3RD STREET SW","ADDRNUM":1001.0,"ADDRNUMSUFFIX":null,"STNAME":"3RD","STREET_TYPE":"STREET","QUADRANT":"SW","CITY":"WASHINGTON","STATE":"DC","XCOORD":398639.34,"YCOORD":134445.54,"SSL":"0542    0079","ANC":"ANC 6D","PSA":"Police Service Area 105","WARD":"Ward 6","NBHD_ACTION":" ","CLUSTER_":"Cluster 9","POLDIST":"Police District - First District","ROC":"NA","CENSUS_TRACT":"010200","VOTE_PRCNCT":"Precinct 128","SMD":"SMD 6D05","ZIPCODE":20024.0,"NATIONALGRID":"18S UJ 25151 05151","ROADWAYSEGID":14875.0,"FOCUS_IMPROVEMENT_AREA":"NA","HAS_ALIAS":"Y","HAS_CONDO_UNIT":"Y","HAS_RES_UNIT":"Y","HAS_SSL":"Y","LATITUDE":38.87784082,"LONGITUDE":-77.01568108,"STREETVIEWURL":"http://maps.google.com/maps?z=16&layer=c&cbll=38.87784082,-77.01568108&cbp=11,271.063131054759,,0,2.09","RES_TYPE":"RESIDENTIAL","WARD_2002":"Ward 6","WARD_2012":"Ward 6","ANC_2002":"ANC 6D","ANC_2012":"ANC 6D","SMD_2002":"SMD 6D03","SMD_2012":"SMD 6D05","IMAGEURL":"http://citizenatlas.dc.gov/mobilevideo","IMAGEDIR":"20041020","IMAGENAME":"OK134250.jpg","ConfidenceLevel":0.0},{"ALIASNAME":"BALD EAGLE @ FORT GREBLE","ADDRESS_ID":301277.0,"STATUS":"ACTIVE","FULLADDRESS":"100 JOLIET STREET SW","ADDRNUM":100.0,"ADDRNUMSUFFIX":null,"STNAME":"JOLIET","STREET_TYPE":"STREET","QUADRANT":"SW","CITY":"WASHINGTON","STATE":"DC","XCOORD":399117.53,"YCOORD":127901.54,"SSL":"0000    0000","ANC":"ANC 8D","PSA":"Police Service Area 708","WARD":"Ward 8","NBHD_ACTION":" ","CLUSTER_":null,"POLDIST":"Police District - Seventh District","ROC":"NA","CENSUS_TRACT":"010900","VOTE_PRCNCT":"Precinct 126","SMD":"SMD 8D02","ZIPCODE":20032.0,"NATIONALGRID":"18S UH 25486 98598","ROADWAYSEGID":15134.0,"FOCUS_IMPROVEMENT_AREA":"NA","HAS_ALIAS":"Y","HAS_CONDO_UNIT":"N","HAS_RES_UNIT":"N","HAS_SSL":"Y","LATITUDE":38.81889022,"LONGITUDE":-77.01016173,"STREETVIEWURL":"http://maps.google.com/maps?z=16&layer=c&cbll=38.81889022,-77.01016173&cbp=11,164.867960850049,,0,2.09","RES_TYPE":"NON RESIDENTIAL","WARD_2002":"Ward 8","WARD_2012":"Ward 8","ANC_2002":"ANC 8D","ANC_2012":"ANC 8D","SMD_2002":"SMD 8D04","SMD_2012":"SMD 8D02","IMAGEURL":"http://citizenatlas.dc.gov/mobilevideo","IMAGEDIR":"NO_IMAGE","IMAGENAME":"No_Image_Available.JPG","ConfidenceLevel":0.0}]}}';            
            controller.length=2;
            controller.service_location();
            
            controller.jstring=null; 
            controller.length=0;
            controller.service_location();
            
            Test.StopTest();   
       
       }
       
       
    static testMethod void review_submit(){
         Test.StartTest();
         
         FlexNoteQuestion__c flexNoteQuestion= new FlexNoteQuestion__c(Code__c='TTTTT',Questions__c='What is your Query?',Answer_Type__c='MultiPicklist', Name='Test4'); 
         insert flexNoteQuestion;
         
         ServiceRequestType__c  serviceRequest=new ServiceRequestType__c (Name='Name',Service_Name__c='Alleylight Repair Investigation');
         insert serviceRequest;
         
         ServiceRequestTypeFlexNote__c  relationQuestion=new ServiceRequestTypeFlexNote__c (Service_Request_Type__c=serviceRequest.id,FlexNote_Question__c=flexNoteQuestion.id);
         insert relationQuestion;
         
         ServiceRequestController.QuestionAnswerWrapper QAW=new ServiceRequestController.QuestionAnswerWrapper(flexNoteQuestion,relationQuestion);
          
         list<ServiceRequestController.QuestionAnswerWrapper> questionAnswerList=new list<ServiceRequestController.QuestionAnswerWrapper>(); 
         questionAnswerList.add(QAW);
         
         ServiceRequestController.ServiceRequestQuestionWrapper innerclass4= new ServiceRequestController.ServiceRequestQuestionWrapper(serviceRequest,questionAnswerList);
         list<ServiceRequestController.ServiceRequestQuestionWrapper > inn=new list<ServiceRequestController.ServiceRequestQuestionWrapper >();
         inn.add(innerclass4);
         
         controller.serviceRequestQuestionWrapList=inn;
         controller.review_submit();     
        
         
         Test.StopTest();
    }
   
    static testMethod void retrieveFlexNoteQuestionsPicklistNonColon(){
            controller.selectedServiceRequestType=getSRType('SR02ZZTT').Id;
            FlexNoteQuestion__c FlexNoteQuestion=new FlexNoteQuestion__c();
            FlexNoteQuestion.Code__c='DOYHFO88';
            FlexNoteQuestion.Name='Test7'; // 3010
            FlexNoteQuestion.Answer_Type__c='Picklist';
            FlexNoteQuestion.AnswerValues__c='xxxx,yyyy';    
            insert FlexNoteQuestion;
            ServiceRequestTypeFlexNote__c ServiceRequestTypeFlexNote=new ServiceRequestTypeFlexNote__c();
            ServiceRequestTypeFlexNote.Service_Request_Type__c=getSRType('SR03ZZTT').Id;
            ServiceRequestTypeFlexNote.FlexNote_Question__c=FlexNoteQuestion.id;
            insert ServiceRequestTypeFlexNote;
            
            system.assert(FlexNoteQuestion.Answer_Type__c=='Picklist');                                                       
            Test.StartTest();
            controller.retrieveFlexNoteQuestions(); 
            Test.StopTest();
     }
     
    static testMethod void retrieveFlexNoteQuestionsPicklistColon(){
            controller.selectedServiceRequestType=getSRType('SR04ZZTT').Id;
            FlexNoteQuestion__c FlexNoteQuestion=new FlexNoteQuestion__c();
            FlexNoteQuestion.Code__c='DOYHFO2';
            FlexNoteQuestion.Name='Test8' ;// 3010
            FlexNoteQuestion.Answer_Type__c='Picklist';
            FlexNoteQuestion.AnswerValues__c='xxxx,yy:yy';    
            insert FlexNoteQuestion;
            ServiceRequestTypeFlexNote__c ServiceRequestTypeFlexNote=new ServiceRequestTypeFlexNote__c();
            ServiceRequestTypeFlexNote.Service_Request_Type__c=getSRType('SR05ZZTT').Id;
            
            ServiceRequestTypeFlexNote.FlexNote_Question__c=FlexNoteQuestion.id;
            insert ServiceRequestTypeFlexNote;
            
            system.assert(FlexNoteQuestion.Answer_Type__c=='Picklist');                                                       
            Test.StartTest();
            controller.retrieveFlexNoteQuestions();
            Test.StopTest();
     }   
     
     static testMethod void retrieveFlexNoteQuestionsMultiPicklist(){
            controller.selectedServiceRequestType=getSRType('SR06ZZTT').Id;
            FlexNoteQuestion__c FlexNoteQuestion=new FlexNoteQuestion__c();
            FlexNoteQuestion.Code__c='DOYHFO4';
            FlexNoteQuestion.Name='Test9';// 3010
            FlexNoteQuestion.Answer_Type__c='MultiPicklist';
            FlexNoteQuestion.AnswerValues__c='xxxx,yy:yy';    
            insert FlexNoteQuestion;
            ServiceRequestTypeFlexNote__c ServiceRequestTypeFlexNote=new ServiceRequestTypeFlexNote__c();
            ServiceRequestTypeFlexNote.Service_Request_Type__c=getSRType('SR07ZZTT').Id;
            ServiceRequestTypeFlexNote.FlexNote_Question__c=FlexNoteQuestion.id;
            insert ServiceRequestTypeFlexNote;
            
            system.assert(FlexNoteQuestion.Answer_Type__c=='MultiPicklist');                                                       
            Test.StartTest();
            controller.retrieveFlexNoteQuestions();
            Test.StopTest();
     } 
     
     
     @isTest(SeeAllData=true) static void testdoSubmit() {
             controller.ServiceLocationRequired = true;
             List<String> result = new List<String>();
             result.add('1500 PENNSYLVANIA AVENUE NW,WASHINGTON,DC 20229');
             List<String> geoRes= new List<String>(); 
             geoRes.add('Address_ID=149350.0:-76.99542510:38.92959081:NE:400396.68:140190.10:ANC 5E:Police Service Area 502:Ward 5:SMD 5E01:Police District - Fifth District:null');
             controller.geo_result= new Map<String,String>();  
             controller.geo_result.put(result[0],geoRes[0]);
             controller.longitude='149350.0' ;
             controller.latitude='-76.99542510' ;
             controller.quadrant='38.92959081' ;
             controller.xcoord='400396.68' ;
             controller.ycoord='140190.10' ;
             controller.anc='ANC 5E' ;
             controller.psa='Police Service Area 502' ;
             controller.ward= 'Ward 5';
             controller.smd= 'SMD 5E01';
             controller.poldist='Police District - Fifth District' ;
             controller.cluster= 'null';
             
             controller.fulladdress ='1500 PENNSYLVANIA AVENUE NW,WASHINGTON,DC 20229';
             
             FlexNoteQuestion__c flexNoteQuestion= new FlexNoteQuestion__c(Code__c='TTTTT',Questions__c='What is your Query?',Answer_Type__c='MultiPicklist', Name='Test5'); 
             insert flexNoteQuestion;
             
             ServiceRequestType__c  serviceRequest=new ServiceRequestType__c (Name='Name',Service_Name__c='Alleylight Repair Investigation');
             insert serviceRequest;
             
             ServiceRequestTypeFlexNote__c  relationQuestion=new ServiceRequestTypeFlexNote__c (Service_Request_Type__c=serviceRequest.id,FlexNote_Question__c=flexNoteQuestion.id);
             insert relationQuestion;
             
             ServiceRequestController.QuestionAnswerWrapper QAW=new ServiceRequestController.QuestionAnswerWrapper(flexNoteQuestion,relationQuestion);
              
             list<ServiceRequestController.QuestionAnswerWrapper> questionAnswerList=new list<ServiceRequestController.QuestionAnswerWrapper>(); 
             questionAnswerList.add(QAW);
             
             
             ServiceRequestController.ServiceRequestQuestionWrapper innerclass4= new ServiceRequestController.ServiceRequestQuestionWrapper(serviceRequest,questionAnswerList);
             list<ServiceRequestController.ServiceRequestQuestionWrapper > inn=new list<ServiceRequestController.ServiceRequestQuestionWrapper >();
             inn.add(innerclass4);
             controller.serviceRequestQuestionWrapList=inn;
              
             contact selcon=new contact(LastName='xyz',email='xyz@gmail.com');
             insert selcon;
             
             controller.selContact=new contact(LastName='xyz',email='xyz@gmail.com');

             Case cas=new Case(Origin='Web',Status='New');
             cas.ContactId=selcon.id; 
             insert cas;
                            
             controller.selContact=selcon;
             controller.selectedCaseId=cas.id;      
             
             controller.doSubmit();
           
    }
    
    @isTest(SeeAllData=true) static void testdoSubmit1() {
             controller.ServiceLocationRequired = true;
             List<String> result = new List<String>();
             result.add('1001 @ WATERFRONT APARTMENTS - 1001 3RD STREET SW');
             List<String> geoRes= new List<String>(); 
             geoRes.add('INTERSECTIONID=149350.0:-76.99542510:38.92959081:NE:400396.68:140190.10:ANC 5E:Police Service Area 502:Ward 5:SMD 5E01:Police District - Fifth District:null');
             controller.geo_result= new Map<String,String>();  
             controller.geo_result.put(result[0],geoRes[0]);
             controller.longitude='149350.0' ;
             controller.latitude='-76.99542510' ;
             controller.quadrant='38.92959081' ;
             controller.xcoord='400396.68' ;
             controller.ycoord='140190.10' ;
             controller.anc='ANC 5E' ;
             controller.psa='Police Service Area 502' ;
             controller.ward= 'Ward 5';
             controller.smd= 'SMD 5E01';
             controller.poldist='Police District - Fifth District' ;
             controller.cluster= 'null';

             controller.fulladdress ='1001 @ WATERFRONT APARTMENTS - 1001 3RD STREET SW';
            
             FlexNoteQuestion__c flexNoteQuestion= new FlexNoteQuestion__c(Code__c='TTTTT',Questions__c='What is your Query?',Answer_Type__c='MultiPicklist', Name='Test6'); 
             insert flexNoteQuestion;
             
             ServiceRequestType__c  serviceRequest=new ServiceRequestType__c (Name='Name',Service_Name__c='Alleylight Repair Investigation');
             insert serviceRequest;
             
             ServiceRequestTypeFlexNote__c  relationQuestion=new ServiceRequestTypeFlexNote__c (Service_Request_Type__c=serviceRequest.id,FlexNote_Question__c=flexNoteQuestion.id);
             insert relationQuestion;
             
             ServiceRequestController.QuestionAnswerWrapper QAW=new ServiceRequestController.QuestionAnswerWrapper(flexNoteQuestion,relationQuestion);
              
             list<ServiceRequestController.QuestionAnswerWrapper> questionAnswerList=new list<ServiceRequestController.QuestionAnswerWrapper>(); 
             questionAnswerList.add(QAW);
             
             
             ServiceRequestController.ServiceRequestQuestionWrapper innerclass4= new ServiceRequestController.ServiceRequestQuestionWrapper(serviceRequest,questionAnswerList);
             list<ServiceRequestController.ServiceRequestQuestionWrapper > inn=new list<ServiceRequestController.ServiceRequestQuestionWrapper >();
             inn.add(innerclass4);
             controller.serviceRequestQuestionWrapList=inn;
              
             contact selcon=new contact(LastName='xyz',email='xyz@gmail.com');
             insert selcon;   
             
             controller.selectedCaseId = null;
             controller.selContact=selcon;
             
             Case cas=new Case(Status='New',Subject='Bulk collection',Origin='Web',Description='comments');
             cas.ContactId=selcon.id;             
             
             //ServiceRequestType_Jurisdiction__c srtj = new  ServiceRequestType_Jurisdiction__c(Id='a05r0000000Fi0f',Name='A1531_PRSVAVOP',SLA__c='15',Jurisdiction__c='a03r00000004Vhs',ServiceRequestType__c='a06r000000048nz');
             //controller.JurdId='a03r00000004Vhs';
             //controller.Sla='15';
             //controller.Agency='DPW';
             insert cas;
             
             controller.casenumber=cas;      
             controller.doSubmit();
           
    }



   
   
 }
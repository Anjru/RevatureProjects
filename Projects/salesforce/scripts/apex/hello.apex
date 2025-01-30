// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);
//System.debug(Calculator.add(1,2));
//System.debug(Calculator.divide(6,2));
//System.debug(Calculator.mod(5,2));
//System.debug(DataLord.numAccounts());
//System.debug(DataLord.numHot());
//System.debug(DataLord.numComplex());
//System.debug(DataLord.bigFive());
//System.debug(DataLord.lastBigOpportunity());
//System.debug(DataLord.majorPlayers());
//System.debug(DataLord.mostPopularAccount());
//System.debug(DataLord.getContactLead());
//System.debug(DataLord.getAccount());
//System.debug(DataLord.getPhone());
//DataLord.spawnContacts();
//DataLord.createHomes();
//DataLord.relocate();
//DataLord.play();
//System.debug(Calculator.calculate('(10.5 * 2 - 10) * 0.5 '));
//Vehicle test = new Vehicle();
//test.toString();

Schedule sb = new Schedule();
String schedule = '0 0 0 ? * 6L';
String jobId = System.schedule('Schedule Name', schedule, sb);

String conId = System.scheduleBatch(new Batch(), 'job', 1);
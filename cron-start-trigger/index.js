const msRestAzure = require('@azure/ms-rest-nodeauth');
const saManagement = require('@azure/arm-streamanalytics');

module.exports = async function (context, startTimer) {

    msRestAzure.loginWithAppServiceMSI({resource: "https://management.azure.com/"}).then((credentials) => {
        console.log('Login Successfuly!');

        const subscriptionId = process.env.SUBSCRIPTION_ID;
        const targetJobs = process.env.TARGET_SA_NAMES_WITH_RG;

        const client = new saManagement.StreamAnalyticsManagementClient(credentials, subscriptionId);

        targetJobs.split(",").forEach((targetJobWithRG) => {
            const target = targetJobWithRG.split("/");
            const resourceGroup = target[0];
            const jobName = target[1];

            console.log("Starting " + jobName + " in " + resourceGroup);
            client.streamingJobs.start(resourceGroup, jobName)
            .then((response) => {
                console.log("Success to start " + jobName + " in " + resourceGroup);
            }).catch(error => {
                console.log('Unexpected error occur during starting stream analytics job : ' + targetJobWithRG);
                console.log(error)
            });
        });
        
    }).catch(error => {
        console.log('error');
        console.log(error);
    });

};

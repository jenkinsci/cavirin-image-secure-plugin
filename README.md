Cavirin Security Platform
====================

Cavirin Security Platform helps DevOps to build continuous security into organization's CI/CD pipeline. Cavirin Platform is equipped with RESTful APIs and it secures cloud and on-prem workloads with rich set of security and compliance benchmarks.  
 
Cavirin Image Secure:

Cavirin Image Secure is a Jenkins plugin which can be used as a security gate for an image build. The plugin connects to Cavirin Platform and orchestrates security assessments for docker images. User defines docker image name and the security framework used to assess the image. By return he receives an overall score for assessment, as well a list of failed policies. Based on this information, Jenkins can pass or fail the security gate automatically.  

Cavirin Image Secure is based on shell script which is wrapped in a java program. The plugin is available for download at Cavirin’s public git repository and is compiled with Maven. The resulted hudson file (.hpi) can then be uploaded  into the Jenkins server. Cavirin Image Secure is published under MIT license and can be freely modified and distributed.

Accessing Cavirin Image Secure:

Go to https://github.com/cavirin/cavirin-image-secure and click clone or download. Copy the link into your shell:
```
git clone https://github.com/cavirin/cavirin-image-secure
```
In order to compile the plugin, move into cavirin-image-secure directory and build the plugin using maven :
```
cd cavirin-image-secure
mvn clean install
```
Once maven has completed, check that the hudson file is available: 
```
ls -l cavirin-image–secure.hpi
```
Move into your Jenkins server and 
Go to plugin manager
Click ‘Advanced’
Choose cavirin-image-secure.hpi for upload
Click upload
Go back to Jenkins dashboard and enter to the project where you are adding the Cavirin image secure build step

Click ‘Configure’
Click ‘Add build step’
Select ‘Cavirin image secure’
Give a name for image scan build step
Cavirin Platform User Name 
Cavirin Platform Password
Registry User Name
Registry Password
Image name in the registry
Policy Pack to scan against
Image Tag like ‘latest'
Cavirin Platform  Address
You can add multiple build steps in order to assess multiple images or to use multiple policy packs

Save the parameters and click ‘Build now’ and observe your build result. By clicking ‘Console Output’ you can observe which tests have failed and need to be remediated. Start remediating the High Severity failures first followed by Medium and Low Severity until you reach your security target and Cavirin Security Scan build steps pass.

You can log into your Cavirin Platform and open the report of the assessment. In the report, you can find instructions how to remediate failed policies.

We hope that you find Cavirin Image Secure as a useful tool in securing your workloads. We would be delighted for any feedback. You can reach us at https://www.cavirin.com

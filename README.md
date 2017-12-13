# Cavirin Security Platform

The Cavirin Security Platform helps DevOps to build continuous security into the CI/CD pipeline. The Platform is equipped with RESTful APIs and secures cloud-based and on-prem workloads with a rich set of security and compliance benchmarks.
## Cavirin Image Secure
Cavirin Image Secure is a Jenkins plugin that can be used as a security gate for an image build. The plugin connects to Cavirin Platform and orchestrates security assessments for Docker images. The user provides the docker image name and the policy pack used to assess the image. In return, the user receives an overall score for assessment and a list of failed policies. Based on this information, Jenkins can automatically pass or fail the security gate.
Cavirin Image Secure is based on a shell script that is wrapped in a Java program. The plugin is available for download from the Jenkins public git repository and is compiled with Maven. Subsequently, the complied Hudson file (.hpi) can be uploaded into the Jenkins server. Cavirin Image Secure is published under the MIT license and can be freely modified and distributed.
## Accessing Cavirin Image Secure
To access Cavirin Image Secure:
1.	Go to https://github.com/jenkinsci/cavirin-image-secure-plugin
2.	Click **clone** or **download**. 
3.	Copy the link into your shell:
```
git clone https://github.com/jenkinsci/cavirin-image-secure-plugin
```
To compile the plugin:
1.	CD into the cavirin-image-secure directory and build the plugin by using Maven:
```
cd cavirin-image-secure
mvn clean install
```
2.	After Maven has finished, ensure that the Hudson file is available:
```
ls -l cavirin-image–secure.hpi
```
Next:

1.	Move into your Jenkins server and go to the plugin manager.
2.	Click **Advanced**.
3.	Select cavirin-image-secure.hpi for upload.
4.	Click **upload**.
5.	Go back to the Jenkins dashboard and enter the project where you are adding the step for the Cavirin image secure build.
6.	Click **Configure**.
7.	Click **Add build step**.
8.	Select **Cavirin image secure**.
9.	Enter the following information:
   -	A name for the image scan build step (for example, “My Image Security”)
   -	Cavirin Platform User Name 
   -	Cavirin Platform Password
   -	Registry User Name
   -	Registry Password
   -	The URL for the image in the registry (https:// docker.io/repo/ubuntu:latest)
   -	The Policy Pack to scan
   -	Tag (a part of the image name in the registry, like “ubuntu:latest”)
   -	Cavirin Platform Address

**NOTE**: You can add multiple build steps to assess multiple images or to use multiple policy packs.

10.	**Save** the parameters.
11.	Click **Build now** and observe your build results.
12.	Click **Console Output** to see the tests that failed and need remediating. The content shows only the failed tests, but the Platform shows all test results whether pass or fail. Seeing only the failed tests can facilitate remediation, so for the next task, Console Output can be considered an option. The Platforms have the option of filtering the display, saving in different formats, and so on.
## Improving the Security Posture
After examining the failed tests and understanding the remediation priorities, you can start on the tasks to raise the security posture to the level your organization requires. 
When Cavirin Image Secure runs, it generates a report on the Cavirin Platform (similar to the automatic report generation that the Platform performs when it assesses an organization’s assets). This report will be a source of guidance for you to remediate the cause of each test failure.
1.	(Optional) Click **Console Output** to see the failed tests. 
2.	Log into the Cavirin Platform and navigate to the Reports screen.
3.	Mark the checkbox next to the name of the completed report for the Image Secure assessment.
4.	Click the **Generate Report** link above the Report Name column. A popup directs you to choose a report format (PDF or Excel) and provide an email address.
5.	Select **Excel** and provide the email address of the report recipient. For each failed test, the report lists the suggested remediation. (Other pathways to suggested remediation exist on the Platform, but getting a report is the simplest for the purpose of this task description.)
6.	Start by remediating the High Severity failures, followed by Medium Severity and then Low Severity. 
7.	After rebuilding the image, re-run Image Secure and see how much the security posture has improved. As needed, repeat this remediation-test sequence until you reach your security target and the Platform security assessments produce a score in the Platform’s Compliance Summary that is both Good and high enough for your security target.

We hope you find Cavirin Image Secure to be a useful tool for securing your workloads. We would be delighted to receive your feedback. You can reach us at https://www.cavirin.com.

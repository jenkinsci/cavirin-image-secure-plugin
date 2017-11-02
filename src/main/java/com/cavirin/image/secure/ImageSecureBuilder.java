package com.cavirin.image.secure;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Arrays;
import javax.servlet.ServletException;
import org.kohsuke.stapler.DataBoundConstructor;
import org.kohsuke.stapler.QueryParameter;
import org.kohsuke.stapler.StaplerRequest;
import hudson.Extension;
import hudson.Launcher;
import hudson.model.AbstractBuild;
import hudson.model.AbstractProject;
import hudson.model.BuildListener;
import hudson.model.Result;
import hudson.tasks.BuildStepDescriptor;
import hudson.tasks.Builder;
import hudson.util.FormValidation;
import net.sf.json.JSONObject;

public class ImageSecureBuilder extends Builder {

	private static final String fileToExecute="/tmp/jenkinsplugin.sh";

	private final String name;
	private final String pulsarusername;
	private final String pulsarpassword;
	private final String dockerusername;
	private final String dockerpassword;
	private final String imagename;
	private final String policypack;
	private final String tag;
	private final String ipaddress;

	@DataBoundConstructor
	public ImageSecureBuilder(String name,String pulsarusername,String pulsarpassword,String dockerusername,String dockerpassword,String imagename,String policypack,String tag,String ipaddress) {
		this.name = name;
		this.pulsarusername=pulsarusername;
		this.pulsarpassword=pulsarpassword;
		this.dockerusername=dockerusername;
		this.dockerpassword=dockerpassword;
		this.imagename=imagename;
		this.policypack=policypack;
		this.tag=tag;
		this.ipaddress=ipaddress;
	}
	public String getName() {
		return name;
	}

	public String getPulsarusername() {
		return pulsarusername;
	}

	public String getPulsarpassword() {
		return pulsarpassword;
	}

	public String getDockerusername() {
		return dockerusername;
	}

	public String getDockerpassword() {
		return dockerpassword;
	}

	public String getImagename() {
		return imagename;
	}

	public String getPolicypack() {
		return policypack;
	}

	public String getTag() {
		return tag;
	}

	public String getIpaddress() {
		return ipaddress;
	}
	public  Result getResult(AbstractBuild<?, ?> build, BuildListener listener) {
		return null;
	}


	@Override
	public boolean perform(@SuppressWarnings("rawtypes") AbstractBuild build, Launcher launcher, BuildListener listener) {
		listener.getLogger().println("Please note that the Docker Image scan with your inputs needs sometime, Wait on with Patience");
		listener.getLogger().println("We will be back real soon");
		try {
			InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("META-INF/jenkinsplugin.sh");
			BufferedReader reader = new BufferedReader((new InputStreamReader(inputStream )));
			BufferedWriter out = new BufferedWriter(new FileWriter("/tmp/jenkinsplugin.sh"));
			String line = "";                       
			listener.getLogger().println("Here is the result of the  the Docker Image scan to happened, The details are:\n");    
			StringBuffer sb = new StringBuffer();
			while ((line = reader.readLine())!= null) {
				sb.append(line+"\n");
			}
			out.write(sb.toString().toCharArray());
			out.flush();
			out.close();
			Runtime run = Runtime.getRuntime();
			Process proces = run.exec("sudo chmod +x "+fileToExecute);
			proces.waitFor();       
			listener.getLogger().println("Please wait for sometime as the results of your Docker Images will be listed very shortly");
			String target = new String(fileToExecute+ ShellConstants.SPACE + ShellConstants.SCRIPT_USERNAMEPARAM + ShellConstants.SPACE+ pulsarusername + ShellConstants.SPACE + ShellConstants.SCRIPT_PASSWORDPARAM +ShellConstants.SPACE +pulsarpassword +ShellConstants.SPACE + ShellConstants.SCRIPT_DOCKERUNAMEPARAM +ShellConstants.SPACE+ dockerusername + ShellConstants.SPACE + ShellConstants.SCRIPT_DOCKERPasswordparam +ShellConstants.SPACE +dockerpassword + ShellConstants.SPACE + ShellConstants.SCRIPT_DOCKERIMAGENAME +ShellConstants.SPACE +tag + ShellConstants.SPACE+ShellConstants.SCRIPT_POLICYPACKPARAM +ShellConstants.SPACE+ policypack+ShellConstants.SPACE+ShellConstants.SCRIPT_TAGPARAM+ShellConstants.SPACE+imagename +ShellConstants.SPACE+ShellConstants.SCRIPT_IPADDRESSPARAM +ShellConstants.SPACE+ipaddress);
			listener.getLogger().println("The shell script that will be executed with the parameters you provided is "+target.toString());
			listener.getLogger().println("Please wait for sometime as the results of your Docker Images will be listed very shortly");
			Runtime rt = Runtime.getRuntime();
			Process proc = rt.exec(target);
			int exitCode = proc.waitFor();
			BufferedReader exitReader = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			String lineOutPut = "";                       
			listener.getLogger().println("Here is the result of the  the Docker Image scan to happened, The details are:");                 
			while ((lineOutPut = exitReader.readLine())!= null) {
				listener.getLogger().println(lineOutPut);
			}
			if(exitCode!=0) return false; 
		}
		catch(Exception e){
			listener.getLogger().println(Arrays.toString(e.getStackTrace()));
		}
		return true;
	}

	@Override
	public DescriptorImpl getDescriptor() {
		return (DescriptorImpl)super.getDescriptor();
	}

	@Extension 
	public static final class DescriptorImpl extends BuildStepDescriptor<Builder> {

		private boolean useFrench;

		public FormValidation doCheckName(@QueryParameter String value)
				throws IOException, ServletException {
			if (value.length() == 0)
				return FormValidation.error("Please set a name");
			if (value.length() < 4)
				return FormValidation.warning("Isn't the name too short?");
			return FormValidation.ok();
		}

		public boolean isApplicable(Class<? extends AbstractProject> aClass) {
			return true;
		}

		public String getDisplayName() {
			return "Cavirin Image Scan";
		}

		@Override
		public boolean configure(StaplerRequest req, JSONObject formData) throws FormException {
			useFrench = formData.getBoolean("useFrench");
			save();
			return super.configure(req,formData);
		}

		public boolean getUseFrench() {
			return useFrench;
		}
	}
}


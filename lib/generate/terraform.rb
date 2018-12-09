module Generate
  class Terraform
    def self.apply_with_log(var_file:, tfvars: {}, profile: 'default', auto_approve: true, log_file: 'crash.log', credentials: '~/.aws/credentials', config: '~/.aws/config')
      arg_string = tfvar_arg_string(tfvars)
      arg_string << " -var-file=#{var_file}" unless var_file.to_s.strip.empty?
      arg_string << " -auto-approve" if auto_approve
      Helper.run!("TF_LOG_PATH=#{log_file} TF_LOG=TRACE AWS_SHARED_CREDENTIALS_FILE=#{credentials} AWS_PROFILE=#{profile} AWS_CONFIG_FILE=#{config} AWS_SDK_LOAD_CONFIG=1 terraform apply #{arg_string}")
    end

    def self.destroy_with_log(var_file:, tfvars: {}, profile: 'default', auto_approve: true, log_file: 'crash.log', credentials: '~/.aws/credentials', config: '~/.aws/config')
      arg_string = tfvar_arg_string(tfvars)
      arg_string << " -var-file=#{var_file}" unless var_file.to_s.strip.empty?
      arg_string << " -auto-approve" if auto_approve
      Helper.run!("TF_LOG_PATH=#{log_file} TF_LOG=TRACE AWS_SHARED_CREDENTIALS_FILE=#{credentials} AWS_PROFILE=#{profile} AWS_CONFIG_FILE=#{config} AWS_SDK_LOAD_CONFIG=1 terraform destroy #{arg_string}")
    end

    def self.tfvar_arg_string(tfvars)
      tfvars.map do |key, value|
        value = "'#{value.to_json}'" if value.respond_to?(:each)
        "-var #{key}=#{value}"
      end.join(' ')
    end

    def self.maybe_create_workspace(workspace_name)
      Logger.info("Creating #{workspace_name} workspace")
      Helper.run!("terraform workspace new #{workspace_name}")
    rescue Error
      Logger.info("Selecting #{workspace_name} workspace")
      Helper.run!("terraform workspace select #{workspace_name}")
    end
  end
end

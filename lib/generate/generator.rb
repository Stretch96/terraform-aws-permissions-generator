module Generate
  class Generator
    require "fileutils"
    require "date"
    def self.run(
      terraform_path,
      var_file: "",
      tfvars: {},
      auto_approve: true,
      log_file: 'crash.log',
      credentials: 'terraform_aws_permissions_generator_user_credentials',
      config: 'terraform_aws_permissions_generator_config',
      policy_path: 'required_permissions.json',
      policy_modifier_path: 'policy_modifier',
      finished_apply: false,
      completed_policies_dir: 'completed_policies'
    )
      clean_up(crash_log: log_file)
      Dir.chdir terraform_path do
        Terraform.maybe_create_workspace('terraform-aws-permissions-generator')
        begin
          if !finished_apply
            Logger.info('Running terraform apply ...')
            Terraform.apply_with_log(
              var_file: var_file,
              tfvars: tfvars,
              auto_approve: auto_approve,
              log_file: log_file,
              credentials: credentials,
              config: config,
              profile: 'generatedpermissions'
            )
          end
          finished_apply = true
          Logger.info('Running terraform destroy ...')
          Terraform.destroy_with_log(
            var_file: var_file,
            tfvars: tfvars,
            auto_approve: auto_approve,
            log_file: log_file,
            credentials: credentials,
            config: config,
            profile: 'generatedpermissions'
          )
          Dir.chdir policy_modifier_path do
            Logger.info('Destroying policy in AWS ...')
            Terraform.destroy_with_log(
              var_file: var_file,
              tfvars: tfvars,
              auto_approve: auto_approve,
              log_file: log_file,
              credentials: credentials
            )
          end
          completed_policy_path = move_required_permissions_to_dir(policy_path, dir: completed_policies_dir)
          clean_up(crash_log: log_file)
          Logger.success("All done :D")
          Logger.success("Policy stored at:")
          Logger.success("  #{completed_policy_path}")
          return
        rescue Error
          Logger.info('Finding permission in crash log ...')
          permissions = LogParser.get_permission_values(log_file: log_file)
          if !permissions.any?
            Logger.warn('No permissions found in log. Terraform may have errored due to reasons other than lack of permissions.')
            clean_up(crash_log: log_file)
            return
          end
          permissions.each do |permission|
            Logger.info("Adding #{permission} to policy")
            PolicyGenerator.add_permission(permission_string: permission, path: policy_path)
          end
          Logger.info("Updating policy ...")
          Dir.chdir policy_modifier_path do
            Terraform.apply_with_log(
              var_file: var_file,
              tfvars: tfvars,
              auto_approve: auto_approve,
              log_file: log_file,
              credentials: credentials
            )
          end
          Logger.info("Policy updated, waiting 5 seconds before continuing ...")
          sleep(5)
          run(
            terraform_path,
            var_file: var_file,
            tfvars: tfvars,
            auto_approve: auto_approve,
            log_file: log_file,
            credentials: credentials,
            config: config,
            policy_path: policy_path,
            policy_modifier_path: policy_modifier_path,
            finished_apply: finished_apply,
            completed_policies_dir: completed_policies_dir
          )
        end
      end
    end

    def self.clean_up(crash_log: 'crash.log')
      if File.exist?(crash_log)
        Logger.info("Deleting crash log ...")
        File.delete(crash_log)
      end
    end

    def self.move_required_permissions_to_dir(policy_path, dir: 'completed_policies')
      datetime = DateTime.now
      dt = datetime.strftime("%Y%m%d%H%M%S")
      new_filename = "#{dt}.json"
      FileUtils.mv(policy_path, "#{dir}/#{new_filename}")
      return "#{dir}/#{new_filename}"
    end
  end
end

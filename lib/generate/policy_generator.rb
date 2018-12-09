module Generate
  class PolicyGenerator
    require 'json'

    def self.policy_file_path
      'required_permissions.json'
    end

    def self.load_policy(path: policy_file_path)
      if File.exist?(path)
        policy = JSON.parse(File.read(path))
      else
        policy = {
          "Version" => "2012-10-17",
          "Statement" => [
            {
              "Effect" => "Allow",
              "Action" => [],
              "Resource" => "*"
            }
          ]
        }
        save_policy(policy: policy)
      end
      policy
    end

   def self.save_policy(policy:,path: policy_file_path)
     File.open(path,"w") do |f|
       f.write(JSON.pretty_generate(policy))
      end
   end

    def self.add_permission(permission_string:, path: policy_file_path)
      policy = load_policy(path: path)
      if !policy["Statement"][0]["Action"].include? permission_string
        policy["Statement"][0]["Action"] << permission_string
        policy["Statement"][0]["Action"].sort!
        save_policy(policy: policy, path: path)
      else
        false
      end
    end
  end
end

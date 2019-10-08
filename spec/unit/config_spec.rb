require 'spec_helper'

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "grafana_ on #{platform}" do
    step_into :grafana_config, :grafana_install, :grafana_config_enterprise, :grafana_config_server
    platform platform

    context 'create config with enterprise license key' do
      recipe do
        grafana_install 'package'

        grafana_config 'config' do
        end

        grafana_config_enterprise 'config' do
          license_path 'license.txt'
        end
      end

      it('should render config file') do
        is_expected.to render_file('/etc/grafana/grafana.ini').with_content(/license.txt/)
      end
    end

    context 'create config without serve from sub path as default' do
      recipe do
        grafana_install 'package'

        grafana_config 'config' do
        end
      end

      it('should not contain serve_from_sub_path by default') do
        is_expected.not_to render_file('/etc/grafana/grafana.ini').with_content(/serve_from_sub_path/)
      end
    end

    context 'create config with server from sub path' do
      recipe do
        grafana_install 'package'

        grafana_config 'config' do
        end

        grafana_config_server 'config' do
          serve_from_sub_path true
        end
      end

      it('should contain serve_from_sub_path') do
        is_expected.to render_file('/etc/grafana/grafana.ini').with_content(/serve_from_sub_path/)
      end
    end
  end
end

# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'

module JavaBuildpack
  module Framework

    # Encapsulates the functionality for enabling dynatrace support.
    class DynaTraceAgent < JavaBuildpack::Component::VersionedDependencyComponent

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        FileUtils.mkdir_p logs_dir
        download_so
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        @droplet.java_opts
        .add_agentpath(@droplet.sandbox + so_name, javaagent_params)
      end

      protected

      SERVER_ENV_VARIABLE = 'DYNATRACE_SERVER'.freeze

      AGENT_NAME_ENV_VARIABLE = 'DYNATRACE_AGENT_NAME'.freeze

      SERVER_AGENT_PARAM    = 'server'.freeze

      WAIT_AGENT_PARAM    = 'wait'.freeze

      TRANSFORMATION_AGENT_PARAM = 'transformationmaxavgwait'.freeze

      STORAGE_AGENT_PARAM        = 'storage'.freeze

      NAME_AGENT_PARAM        = 'name'.freeze

      private_constant :SERVER_ENV_VARIABLE, :SERVER_AGENT_PARAM, :WAIT_AGENT_PARAM, :TRANSFORMATION_AGENT_PARAM, :STORAGE_AGENT_PARAM, :NAME_AGENT_PARAM, :AGENT_NAME_ENV_VARIABLE

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        ENV.key?(SERVER_ENV_VARIABLE) && !ENV[SERVER_ENV_VARIABLE].to_s.empty?
      end

      private

      def application_name
        ENV.key?(AGENT_NAME_ENV_VARIABLE) ? ENV[AGENT_NAME_ENV_VARIABLE] : @application.details['application_name']
      end

      def javaagent_params
        Hash.new.tap do |agentParams|
          agentParams[NAME_AGENT_PARAM] = "#{application_name}"
          agentParams[SERVER_AGENT_PARAM] = ENV[SERVER_ENV_VARIABLE] if supports?
          agentParams[WAIT_AGENT_PARAM] = @configuration[WAIT_AGENT_PARAM] if @configuration.key? WAIT_AGENT_PARAM
          agentParams[TRANSFORMATION_AGENT_PARAM] = @configuration[TRANSFORMATION_AGENT_PARAM] if @configuration.key? TRANSFORMATION_AGENT_PARAM
          agentParams[STORAGE_AGENT_PARAM] = @configuration[STORAGE_AGENT_PARAM] if @configuration.key? STORAGE_AGENT_PARAM
        end
      end

      def logs_dir
        @droplet.sandbox + 'logs'
      end

    end

  end
end

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

require 'spec_helper'
require 'component_helper'
require 'java_buildpack/framework/dyna_trace_agent'

describe JavaBuildpack::Framework::DynaTraceAgent do
  include_context 'component_helper'

  it 'should not detect without DYNATRACE_SERVER environment variable' do
    expect(component.detect).to be_nil
  end

  context do
    let(:environment) { { 'DYNATRACE_SERVER' => '' } }

    it 'should not detect with empty DYNATRACE_SERVER environment variable' do
      expect(component.detect).to be_nil
    end
  end

  context do
    let(:environment) { { 'DYNATRACE_SERVER' => '127.0.0.1' } }

    it 'should detect with DYNATRACE_SERVER environment variable' do
      expect(component.detect).to eq("dyna-trace-agent=#{version}")
    end
  end

  context  do
    let(:environment) do
      { 'test-key'      => 'test-value', 'VCAP_APPLICATION' => vcap_application.to_yaml,
        'VCAP_SERVICES' => vcap_services.to_yaml,
        'DYNATRACE_SERVER' => '127.0.0.1' }
    end
    let(:configuration) { { 'wait' => '45', 'storage' => '.', 'transformationmaxavgwait' => '256' } }

    it 'should add javaagent to JAVA_OPTS with deafult agent name.' do
      component.release
      expect(java_opts).to include("-agentpath:$PWD/.java-buildpack/dyna_trace_agent/dyna_trace_agent-#{version}.so=name=test-application-name,server=127.0.0.1,wait=45,transformationmaxavgwait=256,storage=.")
    end
  end

  context  do
    let(:environment) do
      { 'test-key'      => 'test-value', 'VCAP_APPLICATION' => vcap_application.to_yaml,
        'VCAP_SERVICES' => vcap_services.to_yaml,
        'DYNATRACE_SERVER' => '127.0.0.1',
        'DYNATRACE_AGENT_NAME' => 'yaas_hybris_staged_application_name'
      }
    end
    let(:configuration) { { 'wait' => '45', 'storage' => '.', 'transformationmaxavgwait' => '256' } }

    it 'should add javaagent to JAVA_OPTS with agent name loaded from environment variable' do
      component.release
      expect(java_opts).to include("-agentpath:$PWD/.java-buildpack/dyna_trace_agent/dyna_trace_agent-#{version}.so=name=yaas_hybris_staged_application_name,server=127.0.0.1,wait=45,transformationmaxavgwait=256,storage=.")
    end
  end

end

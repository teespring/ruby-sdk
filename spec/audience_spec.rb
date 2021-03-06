require 'spec_helper'

describe Optimizely::Audience do
  before(:context) do
    @config_body = OptimizelySpec::V1_CONFIG_BODY
    @config_body_JSON = OptimizelySpec::V1_CONFIG_BODY_JSON
  end

  before(:example) do
    @project_instance = Optimizely::Project.new(@config_body_JSON)
  end

  it 'should return true for user_in_experiment? if there are no audiences and no attributes' do
    expect(@project_instance.config).to receive(:get_audience_ids_for_experiment)
                                       .with('test_experiment').and_return([])
    expect(Optimizely::Audience.user_in_experiment?(@project_instance.config,
                                                   'test_experiment',
                                                    nil)).to be true
  end

  it 'should return true for user_in_experiment? if there are no audiences and there are attributes' do
    expect(@project_instance.config).to receive(:get_audience_ids_for_experiment)
                                       .with('test_experiment').and_return([])
    user_attributes = {
      'browser_type' => 'firefox'
    }
    expect(Optimizely::Audience.user_in_experiment?(@project_instance.config,
                                                   'test_experiment',
                                                   user_attributes)).to be true
  end

  it 'should return false for user_in_experiment? if there are audiences but no attributes' do
    expect(Optimizely::Audience.user_in_experiment?(@project_instance.config,
                                                   'test_experiment_with_audience',
                                                   nil)).to be false
  end

  it 'should return true for user_in_experiment? if any one of the audience conditions are met' do
    user_attributes = {
      'browser_type' => 'firefox'
    }

    expect(Optimizely::Audience.user_in_experiment?(@project_instance.config,
                                                   'test_experiment_with_audience',
                                                   user_attributes)).to be true
  end

  it 'should return false for user_in_experiment? if the audience conditions are not met' do
    user_attributes = {
      'browser_type' => 'chrome'
    }

    expect(Optimizely::Audience.user_in_experiment?(@project_instance.config,
                                                   'test_experiment_with_audience',
                                                   user_attributes)).to be false
  end
end

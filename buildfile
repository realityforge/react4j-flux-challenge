require 'buildr/git_auto_version'
require 'buildr/gwt'

desc 'React4j Flux Challenge implementation'
define 'react4j-sithtracker' do
  project.group = 'org.realityforge.react4j.sithtracker'
  compile.options.source = '1.8'
  compile.options.target = '1.8'
  compile.options.lint = 'all'

  project.version = ENV['PRODUCT_VERSION'] if ENV['PRODUCT_VERSION']

  project.processorpath << :react4j_processor
  project.processorpath << :arez_processor
  project.processorpath << [:javax_inject, :dagger_core, :dagger_spi, :dagger_producers, :dagger_compiler, :googlejavaformat, :errorprone, :javapoet, :guava]

  compile.with :javax_annotation,
               :jetbrains_annotations,
               :jsinterop_base,
               :jsinterop_annotations,
               :elemental2_core,
               :elemental2_dom,
               :elemental2_promise,
               :braincheck,
               :react4j_core,
               :react4j_dom,
               :react4j_arez,
               :arez_core,
               :arez_spytools,
               :dagger_core,
               :dagger_core_sources,
               :dagger_gwt,
               :javax_inject,
               :javax_inject_sources,
               :gwt_user

  # Exclude the Dev module if EXCLUDE_GWT_DEV_MODULE is true
  GWT_MODULES = %w(react4j.sithtracker.SithTrackerProd) + (ENV['EXCLUDE_GWT_DEV_MODULE'] == 'true' ? [] : %w(react4j.sithtracker.SithTrackerDev))
  gwt_enhance(project,
              :modules_complete => true,
              :package_jars => false,
              :gwt_modules => GWT_MODULES,
              :module_gwtc_args => {
                'react4j.sithtracker.SithTrackerDev' => %w(-optimize 9 -checkAssertions -XmethodNameDisplayMode FULL -noincremental),
                'react4j.sithtracker.SithTrackerProd' => %w(-XdisableClassMetadata -XdisableCastChecking -optimize 9 -nocheckAssertions -XmethodNameDisplayMode NONE -noincremental -compileReport)
              })

  iml.excluded_directories << project._('tmp')

  ipr.add_component_from_artifact(:idea_codestyle)

  ipr.add_gwt_configuration(project,
                            :gwt_module => 'react4j.sithtracker.SithTrackerDev',
                            :start_javascript_debugger => false,
                            :vm_parameters => "-Xmx2G -Djava.io.tmpdir=#{_('tmp/gwt')}",
                            :shell_parameters => "-style PRETTY -XmethodNameDisplayMode FULL -noincremental -port 8888 -codeServerPort 8889 -bindAddress 0.0.0.0 -war #{_(:generated, 'gwt-export')}/")
end
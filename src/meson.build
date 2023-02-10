pastor_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

pastor_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('libsoup-2.4'),
]

pastor_sources += gnome.compile_resources('pastor-resources',
  '../data/org.pastor.Pastor.gresource.xml',
  c_name: 'pastor',
  source_dir: '../data'
)

executable('pastor', pastor_sources,
  dependencies: pastor_deps,
       install: true,
)

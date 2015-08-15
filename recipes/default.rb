#
# Cookbook Name:: xmonad
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt'

node['xmonad']['dependencies'].each do |name, vers|
  package name do
    if vers == :latest
      action :upgrade
    else
      action :install
      version vers if vers
    end
  end
end

xmonad_user = node['xmonad']['user']

cabal_update xmonad_user

cabal_install 'xmonad' do
  user xmonad_user
end

link '/usr/local/bin/xmonad' do
  to File.join('home', xmonad_user, '.cabal', 'bin', 'xmonad')
  link_type :symbolic
end

cabal_install 'xmonad-contrib' do
  user xmonad_user
end

# this is cheating, but the cabal cookbook doesn't support the "flags" option
cabal_install 'xmobar --flags="all_extensions"' do
  user xmonad_user
end

template '/usr/local/bin/xmonad-init' do
  owner 'root'
  group 'root'
  mode 0777
  action :create_if_missing
end

template '/usr/share/xsessions/xmonad.desktop' do
  owner 'root'
  group 'root'
  mode 0644
  action :create_if_missing
end

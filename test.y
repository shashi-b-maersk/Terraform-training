---
- name: Install Grafana Alloy on Windows
  hosts: 10.125.0.108
  tasks:
    - name: Download Grafana Alloy installer
      win_get_url:
        url: "https://github.com/grafana/alloy/releases/download/v1.1.0/alloy-installer-windows-amd64.exe.zip"
        dest: E:\alloy-installer-windows-amd64.exe.zip

    - name: Unzip the installer
      win_unzip:
        src: E:\alloy-installer-windows-amd64.exe.zip
        dest: E:\

    - name: Install Grafana Alloy
      win_shell: |
        E:\alloy-installer-windows-amd64.exe /S /D=E:\GrafanaLabs\Alloy
      args:
        creates_path: E:\GrafanaLabs\Alloy\alloy.exe

    - name: Set Alloy binary arguments in the registry
      win_regedit:
        path: HKLM:\SOFTWARE\GrafanaLabs\Alloy
        name: Arguments
        data:
          - "run"
          - "E:\\GrafanaLabs\\Alloy\\config.alloy"
          - "--storage.path=E:\\GrafanaLabs\\Alloy\\data"
        type: multistring

    - name: Copy new Grafana Alloy configuration file
      ansible.windows.win_copy:
        src: "{{ playbook_dir }}/config.alloy"
        dest: E:\GrafanaLabs\Alloy\config.alloy
      notify:
        - restart alloy

  handlers:
    - name: restart alloy
      win_service:
        name: alloy
        state: restarted
        start_mode: auto

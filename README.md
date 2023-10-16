# vsftpd-docker

vsftpf (very secure FTP daemon) alpine container

## Available options

| Option        | Description                           |
| ------------- | ------------------------------------- |
| `FTP_USER`    | Username for login. `user` by deafult |
| `FTP_PASS`    | Password for login. `pass` by default |
| `FTP_LOGGING` | Enable logging. `NO` by default       |

Other options may be set using `VSFTPD_` prefix. For example to enable passive mode you can do next:

```bash
docker run -d \
  -p 20-21:20-21 \
  -p 21100-21110:21100-21110 \
  -e FTP_USER=<user> \
  -e FTP_PASS=<password> \
  -e VSFTPD_pasv_enable=YES \
  -e VSFTPD_pasv_address=<server_ip> \
  -e VSFTPD_pasv_min_port=21100 \
  -e VSFTPD_pasv_max_port=21110 \
  -v /path/to/ftp:/home/vsftpd/<user> \
  --name vsftpd --restart=always m0thman/vsftpd
```

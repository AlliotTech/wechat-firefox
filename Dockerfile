FROM linuxserver/firefox:latest

RUN apt-get update && \
    apt-get install -y wget libatomic1 libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-render-util0 libxcb-keysyms1 desktop-file-utils fonts-noto-cjk-extra

RUN wget https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb -O /wechat.deb && \
    apt-get install -y /wechat.deb

ADD menu.xml /defaults/menu.xml
RUN fc-cache -fv

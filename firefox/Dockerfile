FROM linuxserver/firefox:138.0.4

RUN apt-get update && apt-get install -y --no-install-recommends \
            wget \
            libatomic1 \
            libxkbcommon-x11-0 \
            libxcb-icccm4 \
            libxcb-image0 \
            libxcb-render-util0 \
            libxcb-keysyms1 \
            desktop-file-utils \
            fonts-noto-cjk-extra     && \
    wget -q https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb -O /wechat.deb && \
    apt-get install -y --no-install-recommends /wechat.deb && \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/* && rm -f /wechat.deb

COPY menu.xml /defaults/menu.xml
RUN fc-cache -fv

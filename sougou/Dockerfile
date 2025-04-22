FROM --platform=linux/amd64 jlesage/baseimage-gui:ubuntu-20.04-v4

COPY sogou-pinyin.deb /tmp
ENV DEBIAN_FRONTEND=noninteractive
# 设置环境变量和启动脚本
ENV XMODIFIERS="@im=fcitx"
ENV GTK_IM_MODULE="fcitx"
ENV QT_IM_MODULE="fcitx"

# 中国替换APT源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak && \
    sed -i 's@/archive.ubuntu.com/@/mirrors.aliyun.com/@g' /etc/apt/sources.list && \
    sed -i 's@/security.ubuntu.com/@/mirrors.aliyun.com/@g' /etc/apt/sources.list && \
    apt update && \
    apt install -y curl && \
    COUNTRY_CODE=$(curl -s --connect-timeout 3 --max-time 5 https://ifconfig.co/country-iso | tr -d '[:space:]' | awk '{print toupper($0)}') || COUNTRY_CODE=CN && \
    if [ "$COUNTRY_CODE" != "CN" ]; then \
        mv -f /etc/apt/sources.list.bak /etc/apt/sources.list && \
        apt update; \
    fi && \
    # 安装系统语言包、字体等依赖
    apt install -y locales language-pack-zh-hans fonts-noto-cjk-extra \
       shared-mime-info desktop-file-utils libxcb1 libxcb-icccm4 libxcb-image0 \
       libxcb-keysyms1 libxcb-randr0 libxcb-render0 libxcb-render-util0 libxcb-shape0 \
       libxcb-shm0 libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xkb1 libxcb-xinerama0 \
       libxcb-glx0 libatk1.0-0 libatk-bridge2.0-0 libc6 libcairo2 libcups2 \
       libdbus-1-3 libfontconfig1 libgbm1 libgcc1 libgdk-pixbuf2.0-0 libglib2.0-0 \
       libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
       libxcomposite1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 \
       libxss1 libxtst6 libatomic1 libxkbcommon-x11-0 libasound2 lsb-release && \
    # 安装 fcitx 输入法框架和搜狗拼音输入法
    echo "keyboard-configuration keyboard-configuration/layoutcode string cn" | debconf-set-selections && \
    apt install -y fcitx fcitx-config-gtk fcitx-frontend-all && \
    apt purge -y ibus && \
    dpkg --ignore-depends=lsb-core -i /tmp/sogou-pinyin.deb && \
    apt install -y libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1 && \
    apt -f install && \
    cp /usr/share/applications/fcitx.desktop /etc/xdg/autostart/ && \
    im-config -n fcitx && \
    mkdir -p /config/xdg/config/fcitx && \
    echo -e "[Profile]\nDefaultIMList=sogoupinyin\nfcitx-keyboard-us:False" > /config/xdg/config/fcitx/profile && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/sogou-pinyin.deb && \
    # 生成微信图标
    APP_ICON_URL="https://res.wx.qq.com/a/wx_fed/assets/res/NTI4MWU5.ico" && \
    install_app_icon.sh "$APP_ICON_URL" && \
    # 下载微信安装包并安装清理
    curl -O "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb" && \
    dpkg -i WeChatLinux_x86_64.deb 2>&1 | tee /tmp/wechat_install.log && \
    rm WeChatLinux_x86_64.deb && \
    # 创建启动脚本
    echo '#!/bin/sh' > /startapp.sh && \
    echo 'nohup fcitx &>/dev/null &' >> /startapp.sh && \
    echo '(while true; do [ "$(fcitx-remote)" = "1" ] && { fcitx-remote -s sogoupinyin &>/dev/null; break; }; sleep 0.3; done) &' >> /startapp.sh && \
    echo 'while true; do /usr/bin/wechat; echo "WeChat exited. Restarting in 3 seconds..."; sleep 3; done' >> /startapp.sh && \
    chmod +x /startapp.sh && \
    # 配置微信版本号
    set-cont-env APP_VERSION "$(grep -o 'Unpacking wechat ([0-9.]*)' /tmp/wechat_install.log | sed 's/Unpacking wechat (\(.*\))/\1/')"

VOLUME /root/.xwechat
VOLUME /root/xwechat_files
VOLUME /root/downloads

CMD ["/startapp.sh"]

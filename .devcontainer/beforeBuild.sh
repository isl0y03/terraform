# ビルド前にホスト側で実行されるスクリプト
# Docker Composeで読み込む.envファイルにホスト側のUIDとGIDを書き込む
#   WSL2で実行した際に、ファイルパーミッションの問題によりホスト/コンテナ間で
#   ファイルの読み書きができない問題を回避するために、
#   Dockerビルドで作成するユーザのUIDとGIDをホスト側と同一にする
#   おそらくRancher Desktopを使用する場合にはなくても問題ない処理
SCRIPT_DIR=$(dirname $0)
echo "# This file is generated automatically." > $SCRIPT_DIR/../docker/.env
echo "UID=${UID}" >> $SCRIPT_DIR/../docker/.env
echo "GID=$(id -g)" >> $SCRIPT_DIR/../docker/.env

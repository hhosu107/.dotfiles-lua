WSL Docker의 autocompletion은 현재도 제대로 동작하지 않는다.

[link](https://github.com/docker/for-win/issues/13910#issue-2128733301) 에 적힌 것처럼 없는 path로 가고 있다.

이를 해결하려면:

1) zsh 기준으로

`/usr/share/zsh/vendor-completions/_docker`의 symlink를 수정해야 한다.
로컬 home에 `_docker` 파일을 아래와 같이 생성하고:
`docker completion zsh > ~/_docker`

`sudo ln -sf /usr/share/zsh/vendor-completions/_docker ~/_docker` 로 수정.

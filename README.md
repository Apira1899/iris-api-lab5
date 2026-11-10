# Starter kit — Lab 5 (Docker, ACR, Kubernetes/AKS)

ECE Paris — Distributed Systems & Cloud Computing — Dr. BENNAI Soufia — academic year 2026-2027

This folder contains **all the files of the lab, already written and tested** (Python 3.13,
Docker 29, Kubernetes 1.36). You do not need to copy anything from the PDF: read each
file while following the handout, then run the commands.

| File / folder | Role | Part |
|---|---|---|
| `lab5.env.example` | Template of the variables file (copy it to `~/lab5.env`) | 0 |
| `scripts/check-tools.sh` | Checks Docker, az, kubectl, minikube, git | 0 |
| `scripts/find-region.sh` | Finds an allowed region and a VM size for AKS | 0 and 4 |
| `train.py` | Trains the Iris model and saves it | 1 |
| `app/main.py` | FastAPI API (prediction, health, statistics) | 1 |
| `tests/test_api.py` | Automated tests (pytest) | 1 and 5 |
| `requirements*.txt` | Python dependencies, pinned versions | 1 |
| `Dockerfile`, `.dockerignore` | Image build | 1 |
| `Dockerfile.naive` | Counter-example to compare | 1 |
| `compose.yaml` | API + Redis (optional) | 1 |
| `k8s/` | Kubernetes manifests | 3 and 4 |
| `k8s/optional/` | Ingress, KEDA (optional) | 3, bonus |
| `part5/deploy.yml` | GitHub Actions workflow, to copy into `.github/workflows/` **only in Part 5** | 5 |

Quick start (Git Bash on Windows, Terminal on macOS/Linux):

```bash
cd iris-api
cp lab5.env.example ~/lab5.env      # then edit your initials, region and size
bash scripts/check-tools.sh
```

Never commit a secret: `~/lab5.env` stays in your home folder, outside the repository.

# check-in_OU

API de check-in para transporte universitário, construída com **FastAPI + SQLAlchemy + JWT**.

## Rodando o projeto

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
export DATABASE_URL="postgresql+psycopg2://postgres:postgres@localhost:5432/checkin_ou"
uvicorn main:app --reload
```

A documentação Swagger fica disponível em `http://localhost:8000/docs`.

## Principais rotas

- `POST /auth/register`
- `POST /auth/token`
- `POST /formulario`
- `GET /formulario/meu`
- `PUT /formulario`
- `GET /formulario/qrcode`
- `POST /scan/{student_id}`
- `POST /notificar-status`
- `GET /admin/dashboard`
- `POST /feedback`
- `GET /admin/feedbacks`
- `GET /alunos/historico` (aluno)
- `GET /admin/alunos/{student_id}/historico` (admin)

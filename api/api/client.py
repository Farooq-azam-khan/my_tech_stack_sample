import requests
from dataclasses import dataclass


@dataclass
class Client:
    url: str
    headers: dict

    def run_query(self, query: str, variables: dict, extract=False):
        request = requests.post(
            self.url,
            headers=self.headers,
            json={"query": query, "variables": variables},
        )
        assert request.ok, f"Failed with code {request.status_code}"
        return request.json()

    create_user = lambda self, username, password: self.run_query(
        """
            mutation CreateUser($username: String!, $password: String!) {
                insert_user_one(object: {username: $username, password: $password}) {
                    id
                    username
                    password
                }
            }
        """,
        {"username": username, "password": password},
    )

    find_user_by_username = lambda self, username: self.run_query(
        """
        query UserByUsername($username: String!) {
            user(where: {username: {_eq: $username}}, limit: 1) {
                id
                username
                password
            }
        }
    """,
        {"username": username},
    )

    update_password = lambda self, id, password: self.run_query(
        """
        mutation UpdatePassword($id: Int!, $password: String!) {
            update_user_by_pk(pk_columns: {id: $id}, _set: {password: $password}) {
                password
            }
        }
    """,
        {"id": id, "password": password},
    )

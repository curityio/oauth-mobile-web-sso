package io.curity.identityserver.client.errors

class ApplicationException(val errorTitle: String, val errorDescription: String) : RuntimeException()

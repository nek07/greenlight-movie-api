package main

import (
	"net/http"
)

func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {
	data := envelope{"status": "available", "system_info": map[string]string{"environment": app.config.env, "version": version}}
	// headers can accept nil, it will be nil map
	err := app.writeJSON(w, http.StatusOK, data, nil)
	if err != nil {
		app.serveErrorResponse(w, r, err)
	}

}

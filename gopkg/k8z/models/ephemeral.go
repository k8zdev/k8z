package models

type EphemeralPatch struct {
	Spec EphemeralPatchSpec `json:"spec"`
}

type EphemeralPatchSpec struct {
	Ephemeralcontainers []Ephemeralcontainer `json:"ephemeralContainers"`
}

type Ephemeralcontainer struct {
	Name                string   `json:"name"`
	Command             []string `json:"command"`
	Image               string   `json:"image"`
	Targetcontainername string   `json:"targetContainerName"`
	Stdin               bool     `json:"stdin"`
	Tty                 bool     `json:"tty"`
	Volumemounts        []struct {
		Mountpath string `json:"mountPath"`
		Name      string `json:"name"`
		Readonly  bool   `json:"readOnly"`
	} `json:"volumeMounts"`
}

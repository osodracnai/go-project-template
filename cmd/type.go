package cmd

type (
	ConfigServerCmd struct {
		Listen string `mapstructure:"listen"`
		Debug  bool   `mapstructure:"debug"`
	}
)

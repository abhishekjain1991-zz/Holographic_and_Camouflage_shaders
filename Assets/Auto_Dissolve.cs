using UnityEngine;
using System.Collections;

public class Auto_Dissolve : MonoBehaviour {
	float var = 1f;
	bool add_subtract = false;
	void Start () {
		// Use the Specular shader on the material
		renderer.material.shader = Shader.Find("MyDissolveShader");

	}
	void Update ()
	{
				
				if (var < -0.2f) {
						var = var + 0.08f;
						add_subtract = true;
				} else if (var > 1.0f) {
						var = var - 0.08f;
						add_subtract = false;
				}
				if (add_subtract) {
						var = var + 0.008f;
				} else {
						var = var - 0.008f;
				}
		renderer.material.SetFloat("_DissolveVal",var);
		}


}

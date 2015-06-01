using UnityEngine;
using System.Collections;

public class LightMovement : MonoBehaviour {

	public Vector3 movement;
	
	// Update is called once per frame
	void Update () {
		this.transform.Translate(movement * Time.deltaTime, Space.World);
	}
}

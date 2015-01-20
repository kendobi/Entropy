using UnityEngine;
using System.Collections;

[ExecuteInEditMode]

public class SlicedVolume : MonoBehaviour {
	public Material cloudMaterial;
	public int sliceAmount = 25;
	public Vector3 dimensions = new Vector3(500, 50, 500);
	public Vector3 normalDirection = new Vector3(1, 1, 1);
	public bool generateNewSlices;

	MeshFilter meshFilter;
	Mesh slices;
	Vector2[] UvMap;

	Vector3[] verticesPosition;
	int[] triangleConstructor;
	int constructorIncrement = 0;
	int lastVerticesAmount = 0;

	bool updateCloudDirection = true;
	int cameraToCloudRelation = 1;


	void OnEnable(){
		if(transform.gameObject.GetComponent<MeshFilter>())
			meshFilter = transform.gameObject.GetComponent<MeshFilter>();
		else
			meshFilter = transform.gameObject.AddComponent<MeshFilter>();


		if(transform.gameObject.GetComponent<MeshRenderer>() == null){
			//MeshRenderer meshRenderer = new MeshRenderer();
			MeshRenderer meshRenderer = transform.gameObject.AddComponent<MeshRenderer>();
			meshRenderer.castShadows = false;
			meshRenderer.receiveShadows = false;
		}
		generateNewSlices = true;
	}

	void OnRenderObject(){
		checkEditorValues();
		if(generateNewSlices){
			if(cloudMaterial){
				renderer.material = cloudMaterial;
				generateSlicesNow();
			}
			else Debug.Log("No materials assigned, assign CloudMaterial in the inspector");
			generateNewSlices = false;
		}
	}

	void checkEditorValues() {
		sliceAmount = sliceAmount <= 1 ? 2 : sliceAmount;
		//Reverse cloud normals based on the camera position to avoid alpha drawing errors and the need for double sided polygons
		//PreRenderCamera position != to editor camera and game camera position
		if(Camera.current.name != "PreRenderCamera" && cloudMaterial != null){
			if(Camera.current.transform.position.y > transform.position.y && cameraToCloudRelation==-1){
				cameraToCloudRelation = 1;
				updateCloudDirection = true;
			}
			else if(Camera.current.transform.position.y < transform.position.y && cameraToCloudRelation==1){
				cameraToCloudRelation = -1;
				updateCloudDirection = true;
			}

			if(updateCloudDirection){
				transform.localScale = new Vector3(Mathf.Abs(transform.localScale.x), Mathf.Abs(transform.localScale.y)*cameraToCloudRelation, Mathf.Abs(transform.localScale.z));
				Vector4 oldVector = cloudMaterial.GetVector("_CloudNormalsDirection");
				cloudMaterial.SetVector("_CloudNormalsDirection", new Vector4(1*normalDirection.x, normalDirection.y*cameraToCloudRelation, -1*normalDirection.z, oldVector.w));
				updateCloudDirection = false;
			}
		}
	}

	void generateSlicesNow(){
		verticesPosition = new Vector3[sliceAmount*4];
		UvMap = new Vector2[sliceAmount*4];
		triangleConstructor = new int[sliceAmount*6];
		Color[] vertexColor = new Color[sliceAmount*4];

		//From bottom to top
		float heightIncrement = dimensions.y / (sliceAmount-1);
		//
		float mirrorColor = 0;
		float depthColor = -1;
		float colorIncrementMirror = 1.0f/(sliceAmount/2.0f);
		float colorIncrementDepth = 2.0f/sliceAmount;

		bool toggleShadowCaster = true;

		Vector4 oldVector = cloudMaterial.GetVector("_CloudNormalsDirection");
		for(int i = 0; i < sliceAmount; i++){
			//Vertices position
			verticesPosition[0+lastVerticesAmount] = new Vector3(0 - dimensions.x / 2, 0 - (dimensions.y/2) + (heightIncrement*i), 0 - dimensions.z / 2);
			verticesPosition[1+lastVerticesAmount] = new Vector3(0 - dimensions.x / 2, 0 - (dimensions.y/2) + (heightIncrement*i), 0 + dimensions.z / 2);
			verticesPosition[2+lastVerticesAmount] = new Vector3(0 + dimensions.x / 2, 0 - (dimensions.y/2) + (heightIncrement*i), 0 - dimensions.z / 2);
			verticesPosition[3+lastVerticesAmount] = new Vector3(0 + dimensions.x / 2, 0 - (dimensions.y/2) + (heightIncrement*i), 0 + dimensions.z / 2);
			//Uvmap
			UvMap[0+lastVerticesAmount] = new Vector2(0, 0);
			UvMap[1+lastVerticesAmount] = new Vector2(0, 1);
			UvMap[2+lastVerticesAmount] = new Vector2(1, 0);
			UvMap[3+lastVerticesAmount] = new Vector2(1, 1);
			//Triangle
			triangleConstructor[0+constructorIncrement] = 0+lastVerticesAmount;
			triangleConstructor[1+constructorIncrement] = 1+lastVerticesAmount;
			triangleConstructor[2+constructorIncrement] = 2+lastVerticesAmount;
			triangleConstructor[3+constructorIncrement] = 3+lastVerticesAmount;
			triangleConstructor[4+constructorIncrement] = 2+lastVerticesAmount;
			triangleConstructor[5+constructorIncrement] = 1+lastVerticesAmount;
			//Vertex color
			for(int j = 0; j < 4; j++){
				vertexColor[j+lastVerticesAmount] = new Vector4(depthColor, depthColor, depthColor, mirrorColor);
			}
			//increment
			if(i < sliceAmount/2) mirrorColor += colorIncrementMirror;
			else mirrorColor -= colorIncrementMirror;

			depthColor += colorIncrementDepth;
			if(i < sliceAmount/2 && toggleShadowCaster){
				cloudMaterial.SetVector("_CloudNormalsDirection", new Vector4(oldVector.x, oldVector.y, oldVector.z, mirrorColor));
			}
			lastVerticesAmount += 4;
			constructorIncrement += 6;
		}

		lastVerticesAmount = 0;
		constructorIncrement = 0;
		slices = new Mesh();
		slices.name = "VolumeSlices";
		slices.vertices = verticesPosition;
		slices.triangles = triangleConstructor;
		slices.uv = UvMap;
		slices.colors = vertexColor;
		slices.RecalculateNormals();
		calculateMeshTangents(slices);
		slices.Optimize();
		meshFilter.mesh = slices;
	}
	//---------------
	//Credit goes to Julien.Lynge on answers.unity3d.com
	//--------------
	public static void calculateMeshTangents(Mesh mesh)
	{
		//speed up math by copying the mesh arrays
		int[] triangles = mesh.triangles;
		Vector3[] vertices = mesh.vertices;
		Vector2[] uv = mesh.uv;
		Vector3[] normals = mesh.normals;
		
		//variable definitions
		int triangleCount = triangles.Length;
		int vertexCount = vertices.Length;
		
		Vector3[] tan1 = new Vector3[vertexCount];
		Vector3[] tan2 = new Vector3[vertexCount];
		
		Vector4[] tangents = new Vector4[vertexCount];
		
		for (long a = 0; a < triangleCount; a += 3)
		{
			long i1 = triangles[a + 0];
			long i2 = triangles[a + 1];
			long i3 = triangles[a + 2];
			
			Vector3 v1 = vertices[i1];
			Vector3 v2 = vertices[i2];
			Vector3 v3 = vertices[i3];
			
			Vector2 w1 = uv[i1];
			Vector2 w2 = uv[i2];
			Vector2 w3 = uv[i3];
			
			float x1 = v2.x - v1.x;
			float x2 = v3.x - v1.x;
			float y1 = v2.y - v1.y;
			float y2 = v3.y - v1.y;
			float z1 = v2.z - v1.z;
			float z2 = v3.z - v1.z;
			
			float s1 = w2.x - w1.x;
			float s2 = w3.x - w1.x;
			float t1 = w2.y - w1.y;
			float t2 = w3.y - w1.y;
			
			float r = 1.0f / (s1 * t2 - s2 * t1);
			
			Vector3 sdir = new Vector3((t2 * x1 - t1 * x2) * r, (t2 * y1 - t1 * y2) * r, (t2 * z1 - t1 * z2) * r);
			Vector3 tdir = new Vector3((s1 * x2 - s2 * x1) * r, (s1 * y2 - s2 * y1) * r, (s1 * z2 - s2 * z1) * r);
			
			tan1[i1] += sdir;
			tan1[i2] += sdir;
			tan1[i3] += sdir;
			
			tan2[i1] += tdir;
			tan2[i2] += tdir;
			tan2[i3] += tdir;
		}
		
		
		for (long a = 0; a < vertexCount; ++a)
		{
			Vector3 n = normals[a];
			Vector3 t = tan1[a];
			
			//Vector3 tmp = (t - n * Vector3.Dot(n, t)).normalized;
			//tangents[a] = new Vector4(tmp.x, tmp.y, tmp.z);
			Vector3.OrthoNormalize(ref n, ref t);
			tangents[a].x = t.x;
			tangents[a].y = t.y;
			tangents[a].z = t.z;
			
			tangents[a].w = (Vector3.Dot(Vector3.Cross(n, t), tan2[a]) < 0.0f) ? -1.0f : 1.0f;
		}
		
		mesh.tangents = tangents;
	}
}

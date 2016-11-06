using UnityEngine;
using System.Collections;

public class ShowMeshData : MonoBehaviour {

  public Vector3[] verteces;
  public Vector2[] uvs;
  public Color[] colors;

  public int[] triangles;

  [ContextMenu("Show Vertex")]
  void ShowVertex() {
    MeshFilter filter = GetComponent<MeshFilter> ();
    Mesh mesh = filter.sharedMesh;

    verteces = mesh.vertices;
    uvs = mesh.uv;
    colors = mesh.colors;

    triangles = mesh.triangles;
  }

}
